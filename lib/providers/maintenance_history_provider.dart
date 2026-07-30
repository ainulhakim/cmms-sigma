import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/work_order_model.dart';

class MaintenanceHistoryProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();
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
      final data = await _supabase.getMaintenanceHistory(machineId);
      _historyItems = data
          .map((h) => MaintenanceHistoryItem.fromMap(h))
          .toList();
    } catch (e) {
      _error = 'Gagal memuat riwayat perawatan: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }
}
