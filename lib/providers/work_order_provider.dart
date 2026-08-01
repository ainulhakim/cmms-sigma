import 'package:flutter/foundation.dart';
import '../services/database_service.dart';
import '../services/supabase_service.dart';
import '../services/sync_service.dart';
import '../models/work_order.dart';
import '../models/work_order_checklist.dart';
import '../models/work_order_photo.dart';

class WorkOrderProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();
  final DatabaseService _db = DatabaseService();
  final SyncService _syncService = SyncService();

  List<WorkOrder> _workOrders = [];
  List<WorkOrder> get workOrders => _workOrders;

  WorkOrder? _selectedWorkOrder;
  WorkOrder? get selectedWorkOrder => _selectedWorkOrder;

  List<WorkOrderChecklistResult> _checklistResults = [];
  List<WorkOrderChecklistResult> get checklistResults => _checklistResults;

  List<WorkOrderPhoto> _photos = [];
  List<WorkOrderPhoto> get photos => _photos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Alias yang dipakai screens.
  String? get error => _errorMessage;

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  String? _statusFilter;
  String? get statusFilter => _statusFilter;

  String? _priorityFilter;
  String? get priorityFilter => _priorityFilter;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  int _currentPage = 0;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  /// Summary counts
  int _totalCount = 0;
  int get totalCount => _totalCount;
  int _openCount = 0;
  int get openCount => _openCount;
  int _inProgressCount = 0;
  int get inProgressCount => _inProgressCount;
  int _completedCount = 0;
  int get completedCount => _completedCount;

  /// Load work orders with pagination
  Future<void> loadWorkOrders({
    bool refresh = false,
    String? assignedUserId,
  }) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_syncService.isOnline) {
        try {
          final remoteOrders = await _supabase.getWorkOrders(
            status: _statusFilter,
            assignedUserId: assignedUserId,
            page: _currentPage,
            pageSize: 20,
          );

          if (refresh || _currentPage == 0) {
            _workOrders = remoteOrders;
          } else {
            _workOrders.addAll(remoteOrders);
          }

          _hasMore = remoteOrders.length >= 20;
          if (!refresh && remoteOrders.isNotEmpty) {
            _currentPage++;
          }

          // Cache locally
          if (remoteOrders.isNotEmpty) {
            await _db.batchInsert(
              'work_orders',
              remoteOrders.map((wo) => wo.toMap()).toList(),
              clearTableFirst: refresh,
            );
          }
        } catch (e) {
          debugPrint('WorkOrderProvider: Supabase fetch failed ($e), using local');
          // Fallback to local
          try {
            final localData = await _db.query(
              'work_orders',
              where: _statusFilter != null ? 'status = ?' : null,
              whereArgs: _statusFilter != null ? [_statusFilter] : null,
              orderBy: 'created_at DESC',
              limit: 20,
              offset: _currentPage * 20,
            );
            _workOrders = localData.map((map) => WorkOrder.fromMap(map)).toList();
            _hasMore = localData.length >= 20;
          } catch (_) {
            _workOrders = [];
          }
        }
      } else {
        // Load from local DB
        try {
          final localData = await _db.query(
            'work_orders',
            where: _statusFilter != null ? 'status = ?' : null,
            whereArgs: _statusFilter != null ? [_statusFilter] : null,
            orderBy: 'created_at DESC',
            limit: 20,
            offset: _currentPage * 20,
          );
          _workOrders = localData.map((map) => WorkOrder.fromMap(map)).toList();
          _hasMore = localData.length >= 20;
        } catch (_) {
          _workOrders = [];
        }
      }

      // Compute summary counts
      await _loadSummaryCounts(assignedUserId: assignedUserId);
    } catch (e) {
      _errorMessage = 'Gagal memuat work order: ${e.toString()}';
      // Fallback to local
      try {
        final localData = await _db.query(
          'work_orders',
          orderBy: 'created_at DESC',
          limit: 50,
        );
        _workOrders = localData.map((map) => WorkOrder.fromMap(map)).toList();
      } catch (_) {
        _workOrders = [];
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Load summary counts for dashboard badges
  Future<void> _loadSummaryCounts({String? assignedUserId}) async {
    try {
      _totalCount = _workOrders.length;

      final openLocal = _workOrders.where(
        (wo) => wo.status == 'OPEN' || wo.status == 'ASSIGNED',
      ).length;
      _openCount = openLocal;

      final inProgressLocal =
          _workOrders.where((wo) => wo.status == 'IN_PROGRESS').length;
      _inProgressCount = inProgressLocal;

      final completedLocal = _workOrders.where(
        (wo) => wo.status == 'COMPLETED' || wo.status == 'VERIFIED',
      ).length;
      _completedCount = completedLocal;
    } catch (_) {}
  }

  /// Load a single work order with details
  Future<void> loadWorkOrderDetail(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_syncService.isOnline) {
        try {
          _selectedWorkOrder = await _supabase.getWorkOrder(id);
        } catch (e) {
          debugPrint('loadWorkOrderDetail Supabase failed: $e');
        }
      }

      // Fallback to local if online didn't return result
      if (_selectedWorkOrder == null) {
        try {
          final localData = await _db.getById('work_orders', id);
          if (localData != null) {
            _selectedWorkOrder = WorkOrder.fromMap(localData);
          }
        } catch (_) {}
      }

      // Load checklist results
      if (_syncService.isOnline) {
        try {
          _checklistResults = await _supabase.getChecklistResults(id);
          if (_checklistResults.isNotEmpty) {
            await _db.batchInsert(
              'work_order_checklist_results',
              _checklistResults.map((r) => r.toMap()).toList(),
              clearTableFirst: true,
            );
          }
        } catch (_) {}
      }
      if (_checklistResults.isEmpty) {
        try {
          final localChecklist = await _db.query(
            'work_order_checklist_results',
            where: 'work_order_id = ?',
            whereArgs: [id],
          );
          _checklistResults = localChecklist
              .map((map) => WorkOrderChecklistResult.fromMap(map))
              .toList();
        } catch (_) {}
      }

      // Load photos
      if (_syncService.isOnline) {
        try {
          _photos = await _supabase.getWorkOrderPhotos(id);
          if (_photos.isNotEmpty) {
            await _db.batchInsert(
              'work_order_photos',
              _photos.map((p) => p.toMap()).toList(),
              clearTableFirst: true,
            );
          }
        } catch (_) {}
      }
      if (_photos.isEmpty) {
        try {
          final localPhotos = await _db.query(
            'work_order_photos',
            where: 'work_order_id = ?',
            whereArgs: [id],
          );
          _photos =
              localPhotos.map((map) => WorkOrderPhoto.fromMap(map)).toList();
        } catch (_) {}
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Create a work order
  Future<WorkOrder?> createWorkOrder(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      WorkOrder workOrder;
      if (_syncService.isOnline) {
        workOrder = await _supabase.createWorkOrder(data);
      } else {
        // Offline: create locally with temp ID
        workOrder = WorkOrder(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          workOrderNumber: 'TMP-${DateTime.now().millisecondsSinceEpoch}',
          machineId: data['machine_id'] as String? ?? '',
          status: 'OPEN',
        );
        await _db.insert('work_orders', workOrder.toMap());
        await _syncService.queueChange(
          tableName: 'work_orders',
          recordId: workOrder.id,
          operation: 'INSERT',
          payload: data,
        );
      }

      _workOrders.insert(0, workOrder);
      _isLoading = false;
      notifyListeners();
      return workOrder;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Update work order status
  Future<bool> updateStatus(String id, String newStatus) async {
    _errorMessage = null;

    try {
      if (_syncService.isOnline) {
        await _supabase.updateWorkOrderStatus(id, newStatus);
      } else {
        await _syncService.queueChange(
          tableName: 'work_orders',
          recordId: id,
          operation: 'UPDATE',
          payload: {'id': id, 'status': newStatus},
        );
      }

      // Update local cache
      final data = <String, dynamic>{'status': newStatus};
      if (newStatus == 'IN_PROGRESS') {
        data['started_at'] = DateTime.now().toIso8601String();
      } else if (newStatus == 'COMPLETED') {
        data['completed_at'] = DateTime.now().toIso8601String();
      }
      await _db.update('work_orders', data, id);

      // Update in-memory list
      final index = _workOrders.indexWhere((wo) => wo.id == id);
      if (index != -1) {
        _workOrders[index] = _workOrders[index].copyWith(
          status: newStatus,
          startedAt: newStatus == 'IN_PROGRESS'
              ? DateTime.now()
              : _workOrders[index].startedAt,
          completedAt: newStatus == 'COMPLETED'
              ? DateTime.now()
              : _workOrders[index].completedAt,
        );
      }

      // Update selected
      if (_selectedWorkOrder?.id == id) {
        _selectedWorkOrder = _selectedWorkOrder!.copyWith(
          status: newStatus,
          startedAt: newStatus == 'IN_PROGRESS'
              ? DateTime.now()
              : _selectedWorkOrder!.startedAt,
          completedAt: newStatus == 'COMPLETED'
              ? DateTime.now()
              : _selectedWorkOrder!.completedAt,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update work order details
  Future<bool> updateWorkOrder(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_syncService.isOnline) {
        await _supabase.updateWorkOrder(id, data);
      } else {
        await _syncService.queueChange(
          tableName: 'work_orders',
          recordId: id,
          operation: 'UPDATE',
          payload: data,
        );
      }

      await _db.update('work_orders', data, id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Save checklist results
  Future<bool> saveChecklistResults(
      List<WorkOrderChecklistResult> results) async {
    _errorMessage = null;

    try {
      if (_syncService.isOnline) {
        await _supabase.saveChecklistResults(results);
      }

      // Save locally
      for (final result in results) {
        await _db.insert(
          'work_order_checklist_results',
          result.toMap(),
        );
      }

      _checklistResults = results;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Add a photo
  Future<bool> addPhoto(Map<String, dynamic> data) async {
    _errorMessage = null;

    try {
      if (_syncService.isOnline) {
        final photo = await _supabase.addPhoto(data);
        _photos.insert(0, photo);
      } else {
        final photo = WorkOrderPhoto(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          workOrderId: data['work_order_id'] as String? ?? '',
          photoUrl: data['photo_url'] as String? ?? '',
          photoType: data['photo_type'] as String? ?? 'general',
        );
        _photos.insert(0, photo);
        await _db.insert('work_order_photos', photo.toMap());
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Set filters
  void setStatusFilter(String? status) {
    _statusFilter = status;
    _currentPage = 0;
    notifyListeners();
  }

  void setPriorityFilter(String? priority) {
    _priorityFilter = priority;
    _currentPage = 0;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Select work order for detail (menerima ID string)
  Future<void> selectWorkOrder(String id) async {
    _selectedWorkOrder = null;
    await loadWorkOrderDetail(id);
  }

  /// Set tab index pada work order list
  void setSelectedTabIndex(int index) {
    _selectedTabIndex = index;
    switch (index) {
      case 1:
        _statusFilter = 'IN_PROGRESS';
        break;
      case 2:
        _statusFilter = 'COMPLETED';
        break;
      default:
        _statusFilter = null;
    }
    _currentPage = 0;
    notifyListeners();
  }

  /// Start work order (OPEN -> IN_PROGRESS)
  Future<bool> startWorkOrder(String id) async {
    return updateStatus(id, 'IN_PROGRESS');
  }

  /// Complete work order (IN_PROGRESS -> COMPLETED)
  Future<bool> completeWorkOrder(String id,
      [Map<String, dynamic>? data]) async {
    if (data != null && data.isNotEmpty) {
      await updateWorkOrder(id, data);
    }
    return updateStatus(id, 'COMPLETED');
  }

  /// Verify work order (COMPLETED -> VERIFIED)
  Future<bool> verifyWorkOrder(String id, String notes) async {
    await updateWorkOrder(id, {
      'supervisor_notes': notes,
      'verified_by': _supabase.currentUser?.id,
      'verified_at': DateTime.now().toIso8601String(),
    });
    return updateStatus(id, 'VERIFIED');
  }

  /// Get filtered list
  List<WorkOrder> get filteredWorkOrders {
    var result = _workOrders;

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((wo) =>
        wo.workOrderNumber.toLowerCase().contains(query) ||
        (wo.machineName?.toLowerCase().contains(query) ?? false) ||
        (wo.machineCode?.toLowerCase().contains(query) ?? false) ||
        wo.problemDescription.toLowerCase().contains(query)
      ).toList();
    }

    if (_statusFilter != null && _statusFilter!.isNotEmpty) {
      result = result.where((wo) => wo.status == _statusFilter).toList();
    }

    if (_priorityFilter != null && _priorityFilter!.isNotEmpty) {
      result =
          result.where((wo) => wo.priority == _priorityFilter).toList();
    }

    return result;
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
