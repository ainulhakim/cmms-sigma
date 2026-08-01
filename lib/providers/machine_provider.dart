import 'package:flutter/foundation.dart';
import '../services/database_service.dart';
import '../services/supabase_service.dart';
import '../services/sync_service.dart';
import '../models/machine.dart';

class MachineProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();
  final DatabaseService _db = DatabaseService();
  final SyncService _syncService = SyncService();

  List<Machine> _machines = [];
  List<Machine> get machines => _machines;

  /// Alias yang dipakai screens.
  List<Machine> get allMachines => _machines;

  Machine? _selectedMachine;
  Machine? get selectedMachine => _selectedMachine;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Alias yang dipakai screens.
  String? get error => _errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String? _statusFilter;
  String? get statusFilter => _statusFilter;

  /// Load machines from Supabase (or local DB if offline)
  Future<void> loadMachines({bool forceRefresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_syncService.isOnline) {
        // Always try Supabase when online
        try {
          final remoteMachines = await _supabase.getMachines();
          _machines = remoteMachines;
          // Cache locally
          if (remoteMachines.isNotEmpty) {
            await _db.batchInsert(
              'machines',
              remoteMachines.map((m) => m.toMap()).toList(),
              clearTableFirst: true,
            );
          }
        } catch (e) {
          debugPrint('MachineProvider: Supabase fetch failed ($e), using local');
          // Fallback to local on network error
          try {
            final localData = await _db.query('machines', orderBy: 'created_at DESC');
            _machines = localData.map((map) => Machine.fromMap(map)).toList();
          } catch (_) {
            _machines = [];
          }
        }
      } else {
        // Offline: use cached local data
        try {
          final localData = await _db.query('machines', orderBy: 'created_at DESC');
          _machines = localData.map((map) => Machine.fromMap(map)).toList();
        } catch (_) {
          _machines = [];
        }
      }
    } catch (e) {
      _errorMessage = 'Gagal memuat data mesin: ${e.toString()}';
      // Fallback to local data
      try {
        final localData = await _db.query('machines', orderBy: 'created_at DESC');
        _machines = localData.map((map) => Machine.fromMap(map)).toList();
      } catch (_) {
        _machines = [];
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Create a new machine
  Future<Machine?> createMachine(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_syncService.isOnline) {
        final machine = await _supabase.createMachine(data);
        _machines.insert(0, machine);
        await _db.insert('machines', machine.toMap());
        _isLoading = false;
        notifyListeners();
        return machine;
      } else {
        // Offline: create locally and queue for sync
        final localMachine = Machine(
          id: data['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
          machineCode: data['machine_code'] as String? ?? '',
          machineName: data['machine_name'] as String? ?? '',
        );
        _machines.insert(0, localMachine);
        await _db.insert('machines', localMachine.toMap());
        await _syncService.queueChange(
          tableName: 'machines',
          recordId: localMachine.id,
          operation: 'INSERT',
          payload: data,
        );
        _isLoading = false;
        notifyListeners();
        return localMachine;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Update an existing machine
  Future<bool> updateMachine(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_syncService.isOnline) {
        await _supabase.updateMachine(id, data);
      } else {
        await _syncService.queueChange(
          tableName: 'machines',
          recordId: id,
          operation: 'UPDATE',
          payload: data,
        );
      }

      // Update local cache
      await _db.update('machines', data, id);
      final index = _machines.indexWhere((m) => m.id == id);
      if (index != -1) {
        _machines[index] = _machines[index].copyWith(
          machineCode: data['machine_code'] as String?,
          machineName: data['machine_name'] as String?,
          machineNo: data['machine_no'] as String?,
          line: data['line'] as String?,
          location: data['location'] as String?,
          status: data['status'] as String?,
        );
      }

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

  /// Delete a machine
  Future<bool> deleteMachine(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_syncService.isOnline) {
        await _supabase.deleteMachine(id);
      } else {
        await _syncService.queueChange(
          tableName: 'machines',
          recordId: id,
          operation: 'DELETE',
          payload: {'id': id},
        );
      }

      await _db.delete('machines', id);
      _machines.removeWhere((m) => m.id == id);

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

  /// Select a machine for detail view (menerima ID string)
  Future<void> selectMachine(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      if (_syncService.isOnline) {
        _selectedMachine = await _supabase.getMachine(id);
      }

      // Fallback to local if online didn't return result
      if (_selectedMachine == null) {
        try {
          final localData = await _db.getById('machines', id);
          if (localData != null) {
            _selectedMachine = Machine.fromMap(localData);
          }
        } catch (_) {}
      }
    } catch (e) {
      _errorMessage = e.toString();
      // Fallback to local
      try {
        final localData = await _db.getById('machines', id);
        if (localData != null) {
          _selectedMachine = Machine.fromMap(localData);
        }
      } catch (_) {}
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Set status filter
  void setStatusFilter(String? status) {
    _statusFilter = status;
    notifyListeners();
  }

  /// Get filtered machines
  List<Machine> get filteredMachines {
    var result = _machines;

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((m) =>
        m.machineName.toLowerCase().contains(query) ||
        m.machineCode.toLowerCase().contains(query) ||
        m.machineNo.toLowerCase().contains(query) ||
        m.location.toLowerCase().contains(query) ||
        m.line.toLowerCase().contains(query)
      ).toList();
    }

    if (_statusFilter != null && _statusFilter!.isNotEmpty) {
      result = result.where((m) => m.status == _statusFilter).toList();
    }

    return result;
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
