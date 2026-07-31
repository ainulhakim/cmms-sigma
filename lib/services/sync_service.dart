import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'database_service.dart';
import 'supabase_service.dart';

enum SyncStatus { idle, syncing, completed, failed }

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final DatabaseService _db = DatabaseService();
  final SupabaseService _supabase = SupabaseService();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<dynamic>? _connectivitySubscription;

  SyncStatus _status = SyncStatus.idle;
  SyncStatus get status => _status;

  int _pendingCount = 0;
  int get pendingCount => _pendingCount;

  int _syncedCount = 0;
  int get syncedCount => _syncedCount;

  int _failedCount = 0;
  int get failedCount => _failedCount;

  String? _lastErrorMessage;
  String? get lastErrorMessage => _lastErrorMessage;

  DateTime? _lastSyncTime;
  DateTime? get lastSyncTime => _lastSyncTime;

  final StreamController<SyncStatus> _statusController =
      StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get statusStream => _statusController.stream;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        final wasOffline = !_isOnline;
        _isOnline = result != ConnectivityResult.none;

        if (_isOnline && wasOffline) {
          // Came back online - trigger sync
          syncAll();
        }
      },
    );

    // Update pending count
    await _refreshPendingCount();
  }

  /// Dispose subscriptions
  void dispose() {
    _connectivitySubscription?.cancel();
    _statusController.close();
  }

  /// Queue a change for offline sync
  Future<void> queueChange({
    required String tableName,
    required String recordId,
    required String operation,
    required Map<String, dynamic> payload,
    String? userId,
    String deviceId = '',
  }) async {
    await _db.addToSyncQueue(
      tableName: tableName,
      recordId: recordId,
      operation: operation,
      payload: payload,
      userId: userId,
      deviceId: deviceId,
    );
    await _refreshPendingCount();
  }

  /// Sync all pending changes to Supabase
  Future<SyncResult> syncAll() async {
    if (_isSyncing) return SyncResult(isSuccess: false, message: 'Already syncing');
    if (!_isOnline) {
      _setStatus(SyncStatus.idle);
      return SyncResult(isSuccess: false, message: 'No internet connection');
    }

    _isSyncing = true;
    _setStatus(SyncStatus.syncing);
    _syncedCount = 0;
    _failedCount = 0;
    _lastErrorMessage = null;

    try {
      final pendingItems = await _db.getPendingSyncItems();

      if (pendingItems.isEmpty) {
        _setStatus(SyncStatus.completed);
        _lastSyncTime = DateTime.now();
        _isSyncing = false;
        return SyncResult(isSuccess: true, message: 'Nothing to sync');
      }

      for (final item in pendingItems) {
        try {
          await _processSyncItem(item);
          await _db.markSyncItemComplete(item['id'] as String);
          _syncedCount++;
        } catch (e) {
          await _db.markSyncItemFailed(
              item['id'] as String, e.toString());
          _failedCount++;
          _lastErrorMessage = e.toString();
        }
      }

      // Clear old synced items
      await _db.clearSyncedItems();

      final success = _failedCount == 0;
      _setStatus(success ? SyncStatus.completed : SyncStatus.failed);
      _lastSyncTime = DateTime.now();
      await _refreshPendingCount();

      return SyncResult(
        isSuccess: success,
        message: success
            ? 'Sync completed: $_syncedCount items synced'
            : 'Sync completed: $_syncedCount synced, $_failedCount failed',
        syncedCount: _syncedCount,
        failedCount: _failedCount,
      );
    } catch (e) {
      _lastErrorMessage = e.toString();
      _setStatus(SyncStatus.failed);
      return SyncResult(isSuccess: false, message: e.toString());
    } finally {
      _isSyncing = false;
    }
  }

  /// Process a single sync queue item
  Future<void> _processSyncItem(Map<String, dynamic> item) async {
    final tableName = item['table_name'] as String;
    final recordId = item['record_id'] as String;
    final operation = item['operation'] as String;
    final payload = jsonDecode(item['payload'] as String) as Map<String, dynamic>;

    switch (operation) {
      case 'INSERT':
        await _supabase.client.from(tableName).insert(payload);
        break;
      case 'UPDATE':
        await _supabase.client.from(tableName).update(payload).eq('id', recordId);
        break;
      case 'DELETE':
        await _supabase.client.from(tableName).delete().eq('id', recordId);
        break;
      default:
        throw Exception('Unknown operation: $operation');
    }
  }

  /// Sync specific table data from Supabase to local DB
  Future<void> syncTable(String tableName, List<Map<String, dynamic>> records,
      {bool clearFirst = true}) async {
    await _db.batchInsert(tableName, records, clearTableFirst: clearFirst);
  }

  /// Pull latest data from Supabase for offline use
  Future<void> pullAllData() async {
    if (!_isOnline) return;

    try {
      // Pull machines
      final machines = await _supabase.getMachines();
      await _db.batchInsert(
        'machines',
        machines.map((m) => m.toMap()).toList(),
        clearTableFirst: true,
      );

      // Pull maintenance plans
      final plans = await _supabase.getMaintenancePlans();
      await _db.batchInsert(
        'maintenance_plans',
        plans.map((p) => p.toMap()).toList(),
        clearTableFirst: true,
      );

      // Pull work orders (last 100)
      final workOrders = await _supabase.getWorkOrders(pageSize: 100);
      await _db.batchInsert(
        'work_orders',
        workOrders.map((wo) => wo.toMap()).toList(),
        clearTableFirst: true,
      );

      // Pull profiles
      final profiles = await _supabase.getProfiles();
      await _db.batchInsert(
        'profiles',
        profiles.map((p) => p.toMap()).toList(),
        clearTableFirst: true,
      );
    } catch (e) {
      // Silently fail - user can still work with cached data
    }
  }

  /// Refresh the count of pending sync items
  Future<void> _refreshPendingCount() async {
    _pendingCount = await _db.getPendingSyncCount();
  }

  void _setStatus(SyncStatus newStatus) {
    _status = newStatus;
    _statusController.add(newStatus);
  }
}

class SyncResult {
  final bool isSuccess;
  final String message;
  final int syncedCount;
  final int failedCount;

  SyncResult({
    required this.isSuccess,
    required this.message,
    this.syncedCount = 0,
    this.failedCount = 0,
  });
}
