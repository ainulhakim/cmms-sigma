import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/sync_service.dart';

enum SyncState { idle, syncing, completed, failed }

class SyncProvider extends ChangeNotifier {
  final SyncService _syncService = SyncService();

  SyncState _state = SyncState.idle;
  SyncState get state => _state;

  bool get isSyncing => _state == SyncState.syncing;

  int _pendingCount = 0;
  int get pendingCount => _pendingCount;

  int _syncedCount = 0;
  int get syncedCount => _syncedCount;

  int _failedCount = 0;
  int get failedCount => _failedCount;

  String? _lastSyncMessage;
  String? get lastSyncMessage => _lastSyncMessage;

  String? _lastErrorMessage;
  String? get lastErrorMessage => _lastErrorMessage;

  DateTime? _lastSyncTime;
  DateTime? get lastSyncTime => _lastSyncTime;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  double? _syncProgress;
  double? get syncProgress => _syncProgress;

  StreamSubscription? _syncStatusSubscription;

  /// Initialize the sync provider
  Future<void> initialize() async {
    await _syncService.initialize();

    // Listen to sync status changes
    _syncStatusSubscription = _syncService.statusStream.listen((status) {
      switch (status) {
        case SyncStatus.idle:
          _state = SyncState.idle;
          break;
        case SyncStatus.syncing:
          _state = SyncState.syncing;
          break;
        case SyncStatus.completed:
          _state = SyncState.completed;
          _lastSyncTime = _syncService.lastSyncTime;
          _lastSyncMessage =
              'Synced $_syncedCount item${_syncedCount == 1 ? '' : 's'}';
          break;
        case SyncStatus.failed:
          _state = SyncState.failed;
          _lastErrorMessage = _syncService.lastErrorMessage;
          _lastSyncMessage = 'Sync failed: $_lastErrorMessage';
          break;
      }
      _refreshCounts();
      notifyListeners();
    });

    _isOnline = _syncService.isOnline;
    await _refreshCounts();
  }

  /// Trigger full sync
  Future<void> syncAll() async {
    _state = SyncState.syncing;
    _lastErrorMessage = null;
    notifyListeners();

    final result = await _syncService.syncAll();

    _syncedCount = result.syncedCount;
    _failedCount = result.failedCount;

    if (result.isSuccess) {
      _state = SyncState.completed;
      _lastSyncMessage = result.message;
    } else {
      _state = SyncState.failed;
      _lastErrorMessage = result.message;
      _lastSyncMessage = 'Sync failed';
    }

    _lastSyncTime = DateTime.now();
    await _refreshCounts();
    notifyListeners();
  }

  /// Queue a change for offline sync
  Future<void> queueChange({
    required String tableName,
    required String recordId,
    required String operation,
    required Map<String, dynamic> payload,
    String? userId,
  }) async {
    await _syncService.queueChange(
      tableName: tableName,
      recordId: recordId,
      operation: operation,
      payload: payload,
      userId: userId,
    );
    await _refreshCounts();
    notifyListeners();
  }

  /// Pull latest data from server
  Future<void> pullData() async {
    await _syncService.pullAllData();
    await _refreshCounts();
    notifyListeners();
  }

  /// Get pending count
  Future<void> _refreshCounts() async {
    _pendingCount = _syncService.pendingCount;
    _isOnline = _syncService.isOnline;
  }

  /// Reset sync state to idle
  void resetState() {
    _state = SyncState.idle;
    _lastSyncMessage = null;
    _lastErrorMessage = null;
    _syncedCount = 0;
    _failedCount = 0;
    _syncProgress = null;
    notifyListeners();
  }

  /// Format last sync time for display
  String get lastSyncTimeFormatted {
    if (_lastSyncTime == null) return 'Never';
    final diff = DateTime.now().difference(_lastSyncTime!);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  /// Dispose
  @override
  void dispose() {
    _syncStatusSubscription?.cancel();
    super.dispose();
  }
}
