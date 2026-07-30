import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;
  static const String _dbName = 'cmms_sigma.db';
  static const int _dbVersion = 1;

  Database get database {
    if (_database == null) {
      throw StateError('Database not initialized. Call initialize() first.');
    }
    return _database!;
  }

  Future<void> initialize() async {
    if (_database != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    _database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
      singleInstance: true,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE profiles (
        id TEXT PRIMARY KEY,
        email TEXT,
        full_name TEXT NOT NULL DEFAULT '',
        phone TEXT DEFAULT '',
        avatar_url TEXT,
        role TEXT NOT NULL DEFAULT 'technician',
        employee_code TEXT DEFAULT '',
        is_active INTEGER NOT NULL DEFAULT 1,
        fcm_token TEXT,
        preferences TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE machine_categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT DEFAULT '',
        icon TEXT DEFAULT '',
        color TEXT DEFAULT '#2196F3',
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE machines (
        id TEXT PRIMARY KEY,
        machine_code TEXT NOT NULL,
        machine_name TEXT NOT NULL,
        machine_no TEXT DEFAULT '',
        category_id TEXT,
        line TEXT DEFAULT '',
        location TEXT DEFAULT '',
        manufacturer TEXT DEFAULT '',
        model TEXT DEFAULT '',
        serial_number TEXT DEFAULT '',
        installation_date TEXT,
        status TEXT NOT NULL DEFAULT 'active',
        photo_url TEXT DEFAULT '',
        specifications TEXT,
        operating_hours INTEGER DEFAULT 0,
        production_count INTEGER DEFAULT 0,
        notes TEXT DEFAULT '',
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (category_id) REFERENCES machine_categories(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE maintenance_plans (
        id TEXT PRIMARY KEY,
        machine_id TEXT NOT NULL,
        maintenance_name TEXT NOT NULL,
        maintenance_type TEXT NOT NULL DEFAULT 'preventive',
        interval_type TEXT NOT NULL DEFAULT 'DAY',
        interval_value INTEGER NOT NULL DEFAULT 30,
        estimated_duration_minutes INTEGER DEFAULT 60,
        priority TEXT NOT NULL DEFAULT 'medium',
        sop_document_url TEXT DEFAULT '',
        description TEXT DEFAULT '',
        is_active INTEGER NOT NULL DEFAULT 1,
        last_generated_at TEXT,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (machine_id) REFERENCES machines(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE maintenance_checklists (
        id TEXT PRIMARY KEY,
        maintenance_plan_id TEXT NOT NULL,
        item_name TEXT NOT NULL,
        item_type TEXT NOT NULL DEFAULT 'check',
        expected_value TEXT DEFAULT '',
        min_value REAL,
        max_value REAL,
        unit TEXT DEFAULT '',
        sort_order INTEGER NOT NULL DEFAULT 0,
        is_required INTEGER NOT NULL DEFAULT 1,
        notes TEXT DEFAULT '',
        created_at TEXT,
        FOREIGN KEY (maintenance_plan_id) REFERENCES maintenance_plans(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE maintenance_schedules (
        id TEXT PRIMARY KEY,
        maintenance_plan_id TEXT NOT NULL,
        machine_id TEXT NOT NULL,
        scheduled_date TEXT NOT NULL,
        scheduled_start_time TEXT DEFAULT '08:00',
        status TEXT NOT NULL DEFAULT 'pending',
        generated_wo_id TEXT,
        notes TEXT DEFAULT '',
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (maintenance_plan_id) REFERENCES maintenance_plans(id),
        FOREIGN KEY (machine_id) REFERENCES machines(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE work_orders (
        id TEXT PRIMARY KEY,
        work_order_number TEXT NOT NULL,
        machine_id TEXT NOT NULL,
        maintenance_plan_id TEXT,
        assigned_user_id TEXT,
        scheduled_date TEXT,
        started_at TEXT,
        completed_at TEXT,
        status TEXT NOT NULL DEFAULT 'OPEN',
        priority TEXT NOT NULL DEFAULT 'medium',
        problem_description TEXT DEFAULT '',
        action_taken TEXT DEFAULT '',
        root_cause TEXT DEFAULT '',
        downtime_minutes INTEGER DEFAULT 0,
        technician_notes TEXT DEFAULT '',
        supervisor_notes TEXT DEFAULT '',
        verified_by TEXT,
        verified_at TEXT,
        is_sync_complete INTEGER NOT NULL DEFAULT 1,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (machine_id) REFERENCES machines(id),
        FOREIGN KEY (maintenance_plan_id) REFERENCES maintenance_plans(id),
        FOREIGN KEY (assigned_user_id) REFERENCES profiles(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE work_order_checklist_results (
        id TEXT PRIMARY KEY,
        work_order_id TEXT NOT NULL,
        checklist_item_id TEXT,
        item_name TEXT NOT NULL,
        item_type TEXT NOT NULL DEFAULT 'check',
        result_value TEXT DEFAULT '',
        result_bool INTEGER,
        result_decimal REAL,
        is_passed INTEGER,
        notes TEXT DEFAULT '',
        sort_order INTEGER DEFAULT 0,
        created_at TEXT,
        FOREIGN KEY (work_order_id) REFERENCES work_orders(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE work_order_photos (
        id TEXT PRIMARY KEY,
        work_order_id TEXT NOT NULL,
        photo_url TEXT NOT NULL,
        thumbnail_url TEXT DEFAULT '',
        caption TEXT DEFAULT '',
        photo_type TEXT NOT NULL DEFAULT 'general',
        taken_by TEXT,
        taken_at TEXT,
        created_at TEXT,
        FOREIGN KEY (work_order_id) REFERENCES work_orders(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE breakdown_reports (
        id TEXT PRIMARY KEY,
        machine_id TEXT NOT NULL,
        work_order_id TEXT,
        reported_by TEXT,
        breakdown_time TEXT NOT NULL,
        downtime_start TEXT,
        downtime_end TEXT,
        total_downtime_minutes INTEGER DEFAULT 0,
        symptom TEXT NOT NULL,
        root_cause TEXT DEFAULT '',
        impact TEXT DEFAULT '',
        action_taken TEXT DEFAULT '',
        is_resolved INTEGER NOT NULL DEFAULT 0,
        resolved_at TEXT,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (machine_id) REFERENCES machines(id),
        FOREIGN KEY (work_order_id) REFERENCES work_orders(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE spare_parts (
        id TEXT PRIMARY KEY,
        part_code TEXT NOT NULL,
        part_name TEXT NOT NULL,
        description TEXT DEFAULT '',
        category TEXT DEFAULT '',
        unit TEXT NOT NULL DEFAULT 'pcs',
        current_stock INTEGER NOT NULL DEFAULT 0,
        minimum_stock INTEGER NOT NULL DEFAULT 0,
        maximum_stock INTEGER DEFAULT 0,
        location TEXT DEFAULT '',
        supplier TEXT DEFAULT '',
        unit_price REAL DEFAULT 0,
        photo_url TEXT DEFAULT '',
        compatible_machines TEXT DEFAULT '',
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE spare_part_transactions (
        id TEXT PRIMARY KEY,
        spare_part_id TEXT NOT NULL,
        transaction_type TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        reference_type TEXT DEFAULT '',
        reference_id TEXT,
        notes TEXT DEFAULT '',
        performed_by TEXT,
        transaction_date TEXT NOT NULL,
        created_at TEXT,
        FOREIGN KEY (spare_part_id) REFERENCES spare_parts(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        title TEXT NOT NULL,
        body TEXT DEFAULT '',
        notification_type TEXT NOT NULL DEFAULT 'system',
        reference_type TEXT DEFAULT '',
        reference_id TEXT,
        is_read INTEGER NOT NULL DEFAULT 0,
        read_at TEXT,
        action_url TEXT DEFAULT '',
        image_url TEXT DEFAULT '',
        data TEXT,
        created_at TEXT,
        FOREIGN KEY (user_id) REFERENCES profiles(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE sync_queue (
        id TEXT PRIMARY KEY,
        table_name TEXT NOT NULL,
        record_id TEXT NOT NULL,
        operation TEXT NOT NULL,
        payload TEXT NOT NULL,
        user_id TEXT,
        device_id TEXT DEFAULT '',
        status TEXT NOT NULL DEFAULT 'pending',
        error_message TEXT DEFAULT '',
        synced_at TEXT,
        created_at TEXT
      )
    ''');

    // Indexes for performance
    await db.execute('CREATE INDEX idx_machines_status ON machines(status)');
    await db.execute('CREATE INDEX idx_wo_status ON work_orders(status)');
    await db.execute('CREATE INDEX idx_wo_assigned ON work_orders(assigned_user_id)');
    await db.execute('CREATE INDEX idx_wo_machine ON work_orders(machine_id)');
    await db.execute('CREATE INDEX idx_notif_user ON notifications(user_id, is_read)');
    await db.execute('CREATE INDEX idx_sync_status ON sync_queue(status)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future migrations here
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // ============================================================
  // GENERIC CRUD HELPERS
  // ============================================================

  Future<int> insert(String table, Map<String, dynamic> data) async {
    return await database.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(String table, Map<String, dynamic> data, String id,
      {String idColumn = 'id'}) async {
    return await database.update(
      table,
      data,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(String table, String id,
      {String idColumn = 'id'}) async {
    return await database.delete(
      table,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {String? where,
      List<dynamic>? whereArgs,
      String? orderBy,
      int? limit,
      int? offset}) async {
    return await database.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<Map<String, dynamic>?> getById(String table, String id,
      {String idColumn = 'id'}) async {
    final results = await database.query(
      table,
      where: '$idColumn = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> count(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final result = await database.rawQuery(
      'SELECT COUNT(*) as count FROM $table${where != null ? ' WHERE $where' : ''}',
      whereArgs,
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> batchInsert(String table, List<Map<String, dynamic>> records,
      {bool clearTableFirst = false}) async {
    final batch = database.batch();
    if (clearTableFirst) {
      batch.delete(table);
    }
    for (final record in records) {
      batch.insert(table, record,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  // ============================================================
  // SYNC QUEUE OPERATIONS
  // ============================================================

  Future<void> addToSyncQueue({
    required String tableName,
    required String recordId,
    required String operation,
    required Map<String, dynamic> payload,
    String? userId,
    String deviceId = '',
  }) async {
    await database.insert('sync_queue', {
      'id': payload['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'table_name': tableName,
      'record_id': recordId,
      'operation': operation,
      'payload': jsonEncode(payload),
      'user_id': userId,
      'device_id': deviceId,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getPendingSyncItems() async {
    return await database.query(
      'sync_queue',
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'created_at ASC',
    );
  }

  Future<void> markSyncItemComplete(String id) async {
    await database.update(
      'sync_queue',
      {
        'status': 'synced',
        'synced_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markSyncItemFailed(String id, String error) async {
    await database.update(
      'sync_queue',
      {
        'status': 'failed',
        'error_message': error,
        'synced_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getPendingSyncCount() async {
    return await count('sync_queue', where: 'status = ?', whereArgs: ['pending']);
  }

  Future<void> clearSyncedItems() async {
    await database.delete(
      'sync_queue',
      where: 'status = ?',
      whereArgs: ['synced'],
    );
  }
}
