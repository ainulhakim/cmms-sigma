import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../services/database_service.dart';
import '../models/work_order_model.dart';

class DashboardProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();
  final DatabaseService _db = DatabaseService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Alias yang dipakai screens.
  String? get error => _errorMessage;

  // KPI values
  int _totalMachines = 0;
  int get totalMachines => _totalMachines;

  int _activeMachines = 0;
  int get activeMachines => _activeMachines;

  int _machinesUnderMaintenance = 0;
  int get machinesUnderMaintenance => _machinesUnderMaintenance;

  int _openWorkOrders = 0;
  int get openWorkOrders => _openWorkOrders;

  int _inProgressWorkOrders = 0;
  int get inProgressWorkOrders => _inProgressWorkOrders;

  int _completedWorkOrdersToday = 0;
  int get completedWorkOrdersToday => _completedWorkOrdersToday;

  int _overdueWorkOrders = 0;
  int get overdueWorkOrders => _overdueWorkOrders;

  int _unreadNotifications = 0;
  int get unreadNotifications => _unreadNotifications;

  int _pendingBreakdowns = 0;
  int get pendingBreakdowns => _pendingBreakdowns;

  /// Jadwal work order hari ini (dipakai dashboard_screen).
  int get todayScheduleCount => _openWorkOrders;

  /// Work order tertunda (dipakai dashboard_screen).
  int get pendingWOCount => _openWorkOrders + _inProgressWorkOrders;

  /// Total mesin (alias, dipakai dashboard_screen).
  int get totalMachineCount => _totalMachines;

  /// Kirim laporan breakdown (dipakai breakdown_report_screen).
  Future<bool> submitBreakdownReport(BreakdownReportModel report) async {
    try {
      await _supabase.createBreakdownReport(report.toMap());
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  int _lowStockParts = 0;
  int get lowStockParts => _lowStockParts;

  double _averageCompletionTime = 0;
  double get averageCompletionTime => _averageCompletionTime;

  double _overduePercentage = 0;
  double get overduePercentage => _overduePercentage;

  // Monthly stats for charts
  List<Map<String, dynamic>> _monthlyWorkOrders = [];
  List<Map<String, dynamic>> get monthlyWorkOrders => _monthlyWorkOrders;

  List<Map<String, dynamic>> _workOrdersByStatus = [];
  List<Map<String, dynamic>> get workOrdersByStatus => _workOrdersByStatus;

  List<Map<String, dynamic>> _breakdownTrend = [];
  List<Map<String, dynamic>> get breakdownTrend => _breakdownTrend;

  Timer? _autoRefreshTimer;

  /// Initialize and start auto-refresh
  void initialize() {
    loadDashboardData();
    // Auto-refresh every 60 seconds
    _autoRefreshTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => loadDashboardData(),
    );
  }

  /// Load all dashboard data
  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch from Supabase
      final stats = await _supabase.getDashboardStats();

      _totalMachines = stats['totalMachines'] as int? ?? 0;
      _activeMachines = stats['activeMachines'] as int? ?? 0;
      _openWorkOrders = stats['openWorkOrders'] as int? ?? 0;
      _inProgressWorkOrders = stats['inProgressWorkOrders'] as int? ?? 0;
      _completedWorkOrdersToday = stats['completedToday'] as int? ?? 0;
      _unreadNotifications = stats['unreadNotifications'] as int? ?? 0;

      // Fetch extra stats
      await _loadExtraStats();
    } catch (e) {
      _errorMessage = e.toString();
      // Try loading from local DB as fallback
      await _loadFromLocal();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Load additional statistics
  Future<void> _loadExtraStats() async {
    try {
      // Machines under maintenance
      final underMaint = await _supabase.client
          .from('machines')
          .select('id')
          .eq('status', 'under_maintenance')
          .count(CountOption.exact);
      _machinesUnderMaintenance = underMaint.count;

      // Overdue work orders (scheduled before today, not completed)
      final yesterday = DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String()
          .split('T')[0];
      final overdue = await _supabase.client
          .from('work_orders')
          .select('id')
          .lt('scheduled_date', yesterday)
          .inFilter(
              'status', ['OPEN', 'ASSIGNED', 'IN_PROGRESS', 'PAUSED'])
          .count(CountOption.exact);
      _overdueWorkOrders = overdue.count;

      // Unresolved breakdowns
      final breakdowns = await _supabase.client
          .from('breakdown_reports')
          .select('id')
          .eq('is_resolved', false)
          .count(CountOption.exact);
      _pendingBreakdowns = breakdowns.count;

      // Low stock spare parts
      final lowStock = await _supabase.client
          .from('spare_parts')
          .select('id')
          .lte('current_stock', 10)
          .count(CountOption.exact);
      _lowStockParts = lowStock.count;

      // Overdue percentage
      if (_openWorkOrders + _inProgressWorkOrders + _overdueWorkOrders > 0) {
        _overduePercentage = (_overdueWorkOrders /
            (_openWorkOrders + _inProgressWorkOrders + _overdueWorkOrders)) *
            100;
      }

      // Monthly work order stats
      await _loadMonthlyStats();
    } catch (_) {}
  }

  /// Load monthly work order statistics for charts
  Future<void> _loadMonthlyStats() async {
    try {
      // This would be a more complex query in production
      // For now, get last 6 months
      final sixMonthsAgo = DateTime.now()
          .subtract(const Duration(days: 180))
          .toIso8601String();
      final response = await _supabase.client
          .from('work_orders')
          .select('created_at, status')
          .gte('created_at', sixMonthsAgo)
          .order('created_at');

      final orders = response as List;
      final monthlyMap = <String, int>{};

      for (final order in orders) {
        final createdAt = order['created_at'] as String?;
        if (createdAt != null) {
          final month = createdAt.substring(0, 7); // YYYY-MM
          monthlyMap[month] = (monthlyMap[month] ?? 0) + 1;
        }
      }

      _monthlyWorkOrders = monthlyMap.entries
          .map((e) => {'month': e.key, 'count': e.value})
          .toList()
        ..sort((a, b) => (a['month'] as String).compareTo(b['month'] as String));

      // Work orders by status
      final statusMap = <String, int>{};
      for (final order in orders) {
        final status = order['status'] as String? ?? 'UNKNOWN';
        statusMap[status] = (statusMap[status] ?? 0) + 1;
      }
      _workOrdersByStatus = statusMap.entries
          .map((e) => {'status': e.key, 'count': e.value})
          .toList();
    } catch (_) {}
  }

  /// Load from local database as fallback
  Future<void> _loadFromLocal() async {
    try {
      _totalMachines = await _db.count('machines');
      _activeMachines = await _db.count('machines',
          where: 'status = ?', whereArgs: ['active']);

      _openWorkOrders = await _db.count('work_orders',
          where: 'status IN (?, ?)',
          whereArgs: ['OPEN', 'ASSIGNED']);

      _inProgressWorkOrders = await _db.count('work_orders',
          where: 'status = ?', whereArgs: ['IN_PROGRESS']);

      _completedWorkOrdersToday = await _db.count('work_orders',
          where: "status = ? AND date(completed_at) = date('now')",
          whereArgs: ['COMPLETED']);

      _unreadNotifications = await _db.count('notifications',
          where: 'is_read = ?', whereArgs: [0]);

      _pendingBreakdowns = await _db.count('breakdown_reports',
          where: 'is_resolved = ?', whereArgs: [0]);

      _machinesUnderMaintenance = await _db.count('machines',
          where: 'status = ?', whereArgs: ['under_maintenance']);
    } catch (_) {}
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
    await loadDashboardData();
  }

  /// Stop auto-refresh
  void stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }
}
