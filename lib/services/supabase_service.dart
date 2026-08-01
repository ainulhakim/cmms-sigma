import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/machine.dart';
import '../models/maintenance_plan.dart';
import '../models/work_order.dart';
import '../models/work_order_checklist.dart';
import '../models/work_order_photo.dart';
import '../models/breakdown_report.dart';
import '../models/spare_part.dart';
import '../models/notification_model.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  bool get isInitialized {
    try {
      // With service_role key there may not be a session, but client is usable.
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Quick connectivity check – tries a lightweight query.
  Future<bool> ping() async {
    try {
      await client.from('machines').select('id').limit(1);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ============================================================
  // AUTH OPERATIONS
  // ============================================================

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail(
      String email, String password, Map<String, dynamic> userData) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: userData,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // ============================================================
  // PROFILES
  // ============================================================

  Future<UserModel?> getProfile(String userId) async {
    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .limit(1);
      if (response == null || (response as List).isEmpty) return null;
      return UserModel.fromJson((response as List).first as Map<String, dynamic>);
    } catch (e) {
      debugPrint('getProfile error: $e');
      return null;
    }
  }

  Future<List<UserModel>> getProfiles({String? role}) async {
    try {
      var query = client.from('profiles').select();
      if (role != null) {
        query = query.eq('role', role);
      }
      final response = await query;
      return (response as List)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('getProfiles error: $e');
      return [];
    }
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    await client.from('profiles').update(data).eq('id', userId);
  }

  Future<void> updateFcmToken(String userId, String token) async {
    await client
        .from('profiles')
        .update({'fcm_token': token}).eq('id', userId);
  }

  // ============================================================
  // MACHINES
  // ============================================================

  Future<List<Machine>> getMachines({String? status}) async {
    try {
      // Try with join first
      var query = client
          .from('machines')
          .select('*, machine_categories!left(name, icon, color)');
      if (status != null) {
        query = query.eq('status', status);
      }
      final response =
          await query.order('created_at', ascending: false);
      return (response as List)
          .map((json) => Machine.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (joinError) {
      debugPrint('getMachines join failed ($joinError), trying simple query');
      // Fallback: simple query without join
      try {
        var query = client.from('machines').select();
        if (status != null) {
          query = query.eq('status', status);
        }
        final response =
            await query.order('created_at', ascending: false);
        return (response as List)
            .map((json) => Machine.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (simpleError) {
        debugPrint('getMachines simple query also failed: $simpleError');
        rethrow;
      }
    }
  }

  Future<Machine?> getMachine(String id) async {
    try {
      final response = await client
          .from('machines')
          .select('*, machine_categories!left(name, icon, color)')
          .eq('id', id)
          .limit(1);
      if (response == null || (response as List).isEmpty) return null;
      return Machine.fromJson((response as List).first as Map<String, dynamic>);
    } catch (e) {
      // Fallback without join
      try {
        final response = await client
            .from('machines')
            .select()
            .eq('id', id)
            .limit(1);
        if (response == null || (response as List).isEmpty) return null;
        return Machine.fromJson((response as List).first as Map<String, dynamic>);
      } catch (e2) {
        debugPrint('getMachine error: $e2');
        return null;
      }
    }
  }

  Future<Machine> createMachine(Map<String, dynamic> data) async {
    final response = await client.from('machines').insert(data).select().single();
    return Machine.fromJson(response);
  }

  Future<Machine> updateMachine(String id, Map<String, dynamic> data) async {
    final response = await client
        .from('machines')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return Machine.fromJson(response);
  }

  Future<void> deleteMachine(String id) async {
    await client.from('machines').delete().eq('id', id);
  }

  // ============================================================
  // MAINTENANCE PLANS
  // ============================================================

  Future<List<MaintenancePlan>> getMaintenancePlans(
      {String? machineId}) async {
    try {
      var query = client
          .from('maintenance_plans')
          .select('*, machines!left(machine_name, machine_code)');
      if (machineId != null) {
        query = query.eq('machine_id', machineId);
      }
      final response =
          await query.order('created_at', ascending: false);
      return (response as List)
          .map((json) =>
              MaintenancePlan.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('getMaintenancePlans with join failed, trying simple: $e');
      try {
        var query = client.from('maintenance_plans').select();
        if (machineId != null) {
          query = query.eq('machine_id', machineId);
        }
        final response =
            await query.order('created_at', ascending: false);
        return (response as List)
            .map((json) =>
                MaintenancePlan.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e2) {
        debugPrint('getMaintenancePlans simple also failed: $e2');
        rethrow;
      }
    }
  }

  Future<MaintenancePlan?> getMaintenancePlan(String id) async {
    try {
      final response = await client
          .from('maintenance_plans')
          .select('*, machines!left(machine_name, machine_code)')
          .eq('id', id)
          .limit(1);
      if (response == null || (response as List).isEmpty) return null;
      return MaintenancePlan.fromJson(
          (response as List).first as Map<String, dynamic>);
    } catch (e) {
      try {
        final response = await client
            .from('maintenance_plans')
            .select()
            .eq('id', id)
            .limit(1);
        if (response == null || (response as List).isEmpty) return null;
        return MaintenancePlan.fromJson(
            (response as List).first as Map<String, dynamic>);
      } catch (e2) {
        return null;
      }
    }
  }

  Future<MaintenancePlan> createMaintenancePlan(
      Map<String, dynamic> data) async {
    final response = await client
        .from('maintenance_plans')
        .insert(data)
        .select()
        .single();
    return MaintenancePlan.fromJson(response);
  }

  Future<MaintenancePlan> updateMaintenancePlan(
      String id, Map<String, dynamic> data) async {
    final response = await client
        .from('maintenance_plans')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return MaintenancePlan.fromJson(response);
  }

  Future<void> deleteMaintenancePlan(String id) async {
    await client.from('maintenance_plans').delete().eq('id', id);
  }

  // ============================================================
  // WORK ORDERS
  // ============================================================

  Future<List<WorkOrder>> getWorkOrders({
    String? status,
    String? assignedUserId,
    String? machineId,
    String? priority,
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      // Try with joins first
      var query = client
          .from('work_orders')
          .select('''*, machines!inner(machine_name, machine_code), assigned_profile:profiles!work_orders_assigned_user_id_fkey(full_name)''');

      if (status != null) query = query.eq('status', status);
      if (assignedUserId != null) {
        query = query.eq('assigned_user_id', assignedUserId);
      }
      if (machineId != null) query = query.eq('machine_id', machineId);
      if (priority != null) query = query.eq('priority', priority);

      final response = await query
          .order('created_at', ascending: false)
          .range(page * pageSize, (page + 1) * pageSize - 1);
      return _parseWorkOrders(response);
    } catch (joinError) {
      debugPrint('getWorkOrders join failed ($joinError), trying simple');
      // Fallback: simple query without joins
      try {
        var query = client.from('work_orders').select();
        if (status != null) query = query.eq('status', status);
        if (assignedUserId != null) {
          query = query.eq('assigned_user_id', assignedUserId);
        }
        if (machineId != null) query = query.eq('machine_id', machineId);
        if (priority != null) query = query.eq('priority', priority);

        final response = await query
            .order('created_at', ascending: false)
            .range(page * pageSize, (page + 1) * pageSize - 1);
        final results = response as List;
        return results.map((json) {
          return WorkOrder.fromJson(json as Map<String, dynamic>);
        }).toList();
      } catch (simpleError) {
        debugPrint('getWorkOrders simple also failed: $simpleError');
        rethrow;
      }
    }
  }

  List<WorkOrder> _parseWorkOrders(dynamic response) {
    final results = response as List;
    return results.map((json) {
      final wo = WorkOrder.fromJson(json as Map<String, dynamic>);
      // Map joined fields
      final machineJson = json['machines'] as Map<String, dynamic>?;
      if (machineJson != null) {
        wo.machineName = machineJson['machine_name'] as String?;
        wo.machineCode = machineJson['machine_code'] as String?;
      }
      final profileJson = json['assigned_profile'] as Map<String, dynamic>?;
      if (profileJson != null) {
        wo.assignedUserName = profileJson['full_name'] as String?;
      }
      return wo;
    }).toList();
  }

  Future<WorkOrder?> getWorkOrder(String id) async {
    try {
      final response = await client
          .from('work_orders')
          .select('''*, machines!inner(machine_name, machine_code), assigned_profile:profiles!work_orders_assigned_user_id_fkey(full_name, email)''')
          .eq('id', id)
          .limit(1);
      if (response == null || (response as List).isEmpty) return null;
      final json = (response as List).first as Map<String, dynamic>;
      final wo = WorkOrder.fromJson(json);
      final machineJson = json['machines'] as Map<String, dynamic>?;
      if (machineJson != null) {
        wo.machineName = machineJson['machine_name'] as String?;
        wo.machineCode = machineJson['machine_code'] as String?;
      }
      final profileJson = json['assigned_profile'] as Map<String, dynamic>?;
      if (profileJson != null) {
        wo.assignedUserName = profileJson['full_name'] as String?;
      }
      return wo;
    } catch (e) {
      // Fallback without joins
      try {
        final response = await client
            .from('work_orders')
            .select()
            .eq('id', id)
            .limit(1);
        if (response == null || (response as List).isEmpty) return null;
        return WorkOrder.fromJson(
            (response as List).first as Map<String, dynamic>);
      } catch (e2) {
        debugPrint('getWorkOrder error: $e2');
        return null;
      }
    }
  }

  Future<WorkOrder> createWorkOrder(Map<String, dynamic> data) async {
    final response =
        await client.from('work_orders').insert(data).select().single();
    return WorkOrder.fromJson(response);
  }

  Future<WorkOrder> updateWorkOrder(String id, Map<String, dynamic> data) async {
    final response = await client
        .from('work_orders')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return WorkOrder.fromJson(response);
  }

  Future<void> updateWorkOrderStatus(
      String id, String status) async {
    final data = <String, dynamic>{'status': status};
    if (status == 'IN_PROGRESS') {
      data['started_at'] = DateTime.now().toIso8601String();
    } else if (status == 'COMPLETED') {
      data['completed_at'] = DateTime.now().toIso8601String();
    }
    await client.from('work_orders').update(data).eq('id', id);
  }

  // ============================================================
  // WORK ORDER CHECKLIST RESULTS
  // ============================================================

  Future<List<WorkOrderChecklistResult>> getChecklistResults(
      String workOrderId) async {
    try {
      final response = await client
          .from('work_order_checklist_results')
          .select()
          .eq('work_order_id', workOrderId)
          .order('sort_order');
      return (response as List)
          .map((json) => WorkOrderChecklistResult.fromJson(
              json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('getChecklistResults error: $e');
      return [];
    }
  }

  Future<void> saveChecklistResults(
      List<WorkOrderChecklistResult> results) async {
    final batch = client.from('work_order_checklist_results');
    for (final result in results) {
      await batch.upsert(result.toJson());
    }
  }

  // ============================================================
  // WORK ORDER PHOTOS
  // ============================================================

  Future<List<WorkOrderPhoto>> getWorkOrderPhotos(String workOrderId) async {
    try {
      final response = await client
          .from('work_order_photos')
          .select()
          .eq('work_order_id', workOrderId)
          .order('created_at');
      return (response as List)
          .map((json) =>
              WorkOrderPhoto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('getWorkOrderPhotos error: $e');
      return [];
    }
  }

  Future<WorkOrderPhoto> addPhoto(Map<String, dynamic> data) async {
    final response =
        await client.from('work_order_photos').insert(data).select().single();
    return WorkOrderPhoto.fromJson(response);
  }

  // ============================================================
  // BREAKDOWN REPORTS
  // ============================================================

  Future<List<BreakdownReport>> getBreakdownReports(
      {String? machineId, bool? isResolved}) async {
    try {
      var query = client
          .from('breakdown_reports')
          .select('''*, machines!inner(machine_name, machine_code), reporter:profiles!breakdown_reports_reported_by_fkey(full_name)''');
      if (machineId != null) query = query.eq('machine_id', machineId);
      if (isResolved != null) query = query.eq('is_resolved', isResolved);
      final response =
          await query.order('breakdown_time', ascending: false);
      return (response as List).map((json) {
        final br = BreakdownReport.fromJson(json as Map<String, dynamic>);
        final machineJson = json['machines'] as Map<String, dynamic>?;
        if (machineJson != null) {
          br.machineName = machineJson['machine_name'] as String?;
          br.machineCode = machineJson['machine_code'] as String?;
        }
        final reporterJson = json['reporter'] as Map<String, dynamic>?;
        if (reporterJson != null) {
          br.reportedByName = reporterJson['full_name'] as String?;
        }
        return br;
      }).toList();
    } catch (e) {
      debugPrint('getBreakdownReports with join failed, trying simple: $e');
      try {
        var query = client.from('breakdown_reports').select();
        if (machineId != null) query = query.eq('machine_id', machineId);
        if (isResolved != null) query = query.eq('is_resolved', isResolved);
        final response =
            await query.order('breakdown_time', ascending: false);
        return (response as List)
            .map((json) =>
                BreakdownReport.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e2) {
        debugPrint('getBreakdownReports simple also failed: $e2');
        rethrow;
      }
    }
  }

  Future<BreakdownReport> createBreakdownReport(
      Map<String, dynamic> data) async {
    final response = await client
        .from('breakdown_reports')
        .insert(data)
        .select()
        .single();
    return BreakdownReport.fromJson(response);
  }

  // ============================================================
  // SPARE PARTS
  // ============================================================

  Future<List<SparePart>> getSpareParts({bool? lowStockOnly}) async {
    try {
      var query = client.from('spare_parts').select();
      if (lowStockOnly == true) {
        query = query.lte('current_stock', 10);
      }
      final response = await query.order('part_name');
      return (response as List)
          .map((json) => SparePart.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('getSpareParts error: $e');
      return [];
    }
  }

  Future<SparePart> createSparePart(Map<String, dynamic> data) async {
    final response =
        await client.from('spare_parts').insert(data).select().single();
    return SparePart.fromJson(response);
  }

  Future<SparePart> updateSparePart(String id, Map<String, dynamic> data) async {
    final response = await client
        .from('spare_parts')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return SparePart.fromJson(response);
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  Future<List<NotificationModel>> getNotifications(
      {bool? unreadOnly, int page = 0, int pageSize = 20}) async {
    try {
      var query = client.from('notifications').select();
      if (unreadOnly == true) {
        query = query.eq('is_read', false);
      }
      final response = await query
          .order('created_at', ascending: false)
          .range(page * pageSize, (page + 1) * pageSize - 1);
      return (response as List)
          .map((json) =>
              NotificationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('getNotifications error: $e');
      return [];
    }
  }

  Future<int> getUnreadNotificationCount() async {
    try {
      final response = await client
          .from('notifications')
          .select('id')
          .eq('is_read', false)
          .count(CountOption.exact);
      return response.count;
    } catch (e) {
      debugPrint('getUnreadNotificationCount error: $e');
      return 0;
    }
  }

  Future<void> markNotificationRead(String id) async {
    await client.from('notifications').update({
      'is_read': true,
      'read_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> markAllNotificationsRead() async {
    await client.from('notifications').update({
      'is_read': true,
      'read_at': DateTime.now().toIso8601String(),
    }).eq('is_read', false);
  }

  // ============================================================
  // DASHBOARD / AGGREGATE QUERIES
  // ============================================================

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final results = await Future.wait([
        client.from('machines').select('id').count(CountOption.exact),
        client
            .from('machines')
            .select('id')
            .eq('status', 'active')
            .count(CountOption.exact),
        client
            .from('work_orders')
            .select('id')
            .inFilter('status', ['OPEN', 'ASSIGNED'])
            .count(CountOption.exact),
        client
            .from('work_orders')
            .select('id')
            .eq('status', 'IN_PROGRESS')
            .count(CountOption.exact),
        client
            .from('work_orders')
            .select('id')
            .eq('status', 'COMPLETED')
            .gte('completed_at',
                DateTime.now().subtract(const Duration(days: 1)).toIso8601String())
            .count(CountOption.exact),
        client
            .from('notifications')
            .select('id')
            .eq('is_read', false)
            .count(CountOption.exact),
      ]);

      return {
        'totalMachines': (results[0] as PostgrestResponse).count,
        'activeMachines': (results[1] as PostgrestResponse).count,
        'openWorkOrders': (results[2] as PostgrestResponse).count,
        'inProgressWorkOrders': (results[3] as PostgrestResponse).count,
        'completedToday': (results[4] as PostgrestResponse).count,
        'unreadNotifications': (results[5] as PostgrestResponse).count,
      };
    } catch (e) {
      debugPrint('getDashboardStats error: $e');
      // Return zeros on error
      return {
        'totalMachines': 0,
        'activeMachines': 0,
        'openWorkOrders': 0,
        'inProgressWorkOrders': 0,
        'completedToday': 0,
        'unreadNotifications': 0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> getMaintenanceHistory(
      String machineId) async {
    try {
      final response = await client
          .from('work_orders')
          .select('''id, work_order_number, machine_id, maintenance_type, status, completed_at, started_at, technician_notes, assigned_profile:profiles!work_orders_assigned_user_id_fkey(full_name)''')
          .eq('machine_id', machineId)
          .eq('status', 'COMPLETED')
          .order('completed_at', ascending: false);
      return (response as List)
          .map((json) {
            final map = Map<String, dynamic>.from(json as Map);
            map['wo_number'] = map['work_order_number'];
            map['type'] = map['maintenance_type'];
            map['technician_name'] = map['assigned_profile'] is Map
                ? (map['assigned_profile'] as Map)['full_name']
                : null;
            final started = map['started_at'] != null
                ? DateTime.tryParse(map['started_at'] as String)
                : null;
            final completed = map['completed_at'] != null
                ? DateTime.tryParse(map['completed_at'] as String)
                : null;
            if (started != null && completed != null) {
              map['duration_minutes'] =
                  completed.difference(started).inMinutes;
            }
            return map;
          })
          .toList();
    } catch (e) {
      debugPrint('getMaintenanceHistory with join failed, trying simple: $e');
      try {
        final response = await client
            .from('work_orders')
            .select('id, work_order_number, machine_id, maintenance_type, status, completed_at, started_at, technician_notes')
            .eq('machine_id', machineId)
            .eq('status', 'COMPLETED')
            .order('completed_at', ascending: false);
        return (response as List)
            .map((json) {
              final map = Map<String, dynamic>.from(json as Map);
              map['wo_number'] = map['work_order_number'];
              map['type'] = map['maintenance_type'];
              final started = map['started_at'] != null
                  ? DateTime.tryParse(map['started_at'] as String)
                  : null;
              final completed = map['completed_at'] != null
                  ? DateTime.tryParse(map['completed_at'] as String)
                  : null;
              if (started != null && completed != null) {
                map['duration_minutes'] =
                    completed.difference(started).inMinutes;
              }
              return map;
            })
            .toList();
      } catch (e2) {
        debugPrint('getMaintenanceHistory simple also failed: $e2');
        return [];
      }
    }
  }

  Future<List<Map<String, dynamic>>> getWorkOrdersByStatus() async {
    try {
      final response = await client
          .from('work_orders')
          .select('status, count')
          .order('status');
      return (response as List)
          .map((json) => Map<String, dynamic>.from(json as Map))
          .toList();
    } catch (e) {
      debugPrint('getWorkOrdersByStatus error: $e');
      return [];
    }
  }
}
