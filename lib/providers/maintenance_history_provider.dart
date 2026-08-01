import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../services/sync_service.dart';
import '../models/work_order_model.dart';

class MaintenanceHistoryProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();
  final SyncService _syncService = SyncService();
  List<MaintenanceHistoryItem> _historyItems = [];
  bool _isLoading = false;
  String? _error;

  List<MaintenanceHistoryItem> get historyItems => _historyItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadHistory(String machineId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_syncService.isOnline) {
        try {
          final data = await _supabase.getMaintenanceHistory(machineId);
          _historyItems = data
              .map((h) => MaintenanceHistoryItem.fromMap(h))
              .toList();
        } catch (e) {
          debugPrint('MaintenanceHistoryProvider: Supabase fetch failed: $e');
          _error = 'Gagal memuat riwayat perawatan dari server';
        }
      } else {
        _error = 'Gagal memuat riwayat perawatan: tidak ada koneksi internet';
      }
    } catch (e) {
      _error = 'Gagal memuat riwayat perawatan: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }
}
