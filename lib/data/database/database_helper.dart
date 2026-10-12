import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('alpha_product.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Users table (for authentication)
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'employee',
        created_at TEXT NOT NULL
      )
    ''');

    // Attendance table
    await db.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        check_in_time TEXT,
        check_out_time TEXT,
        check_in_lat REAL,
        check_in_lng REAL,
        check_out_lat REAL,
        check_out_lng REAL,
        check_in_address TEXT,
        check_out_address TEXT,
        status TEXT NOT NULL DEFAULT 'pending',
        working_hours REAL DEFAULT 0,
        selfie_path TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Vehicles table
    await db.execute('''
      CREATE TABLE vehicles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plate_number TEXT UNIQUE NOT NULL,
        model TEXT NOT NULL,
        type TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'active',
        current_lat REAL,
        current_lng REAL,
        fuel_level INTEGER DEFAULT 100,
        last_updated TEXT
      )
    ''');

    // Trips table
    await db.execute('''
      CREATE TABLE trips (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicle_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT,
        start_lat REAL,
        start_lng REAL,
        end_lat REAL,
        end_lng REAL,
        start_address TEXT,
        end_address TEXT,
        distance REAL DEFAULT 0,
        status TEXT NOT NULL DEFAULT 'in_progress',
        FOREIGN KEY (vehicle_id) REFERENCES vehicles (id),
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Customers table
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        gst_number TEXT,
        type TEXT NOT NULL DEFAULT 'customer',
        status TEXT NOT NULL DEFAULT 'active',
        created_at TEXT NOT NULL
      )
    ''');

    // Products table
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        sku TEXT UNIQUE NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        stock INTEGER NOT NULL DEFAULT 0,
        category TEXT,
        image_path TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Deliveries table
    await db.execute('''
      CREATE TABLE deliveries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        delivery_number TEXT UNIQUE NOT NULL,
        customer_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        vehicle_id INTEGER,
        status TEXT NOT NULL DEFAULT 'pending',
        address TEXT NOT NULL,
        lat REAL,
        lng REAL,
        assigned_date TEXT NOT NULL,
        delivered_date TEXT,
        delivery_photo_path TEXT,
        signature_path TEXT,
        notes TEXT,
        FOREIGN KEY (customer_id) REFERENCES customers (id),
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (vehicle_id) REFERENCES vehicles (id)
      )
    ''');

    // Orders table
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        order_number TEXT UNIQUE NOT NULL,
        total_amount REAL NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        order_date TEXT NOT NULL,
        delivery_date TEXT,
        notes TEXT,
        FOREIGN KEY (customer_id) REFERENCES customers (id)
      )
    ''');

    // Order items table
    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders (id),
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');

    // Visits table
    await db.execute('''
      CREATE TABLE visits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        visit_date TEXT NOT NULL,
        check_in_time TEXT,
        check_out_time TEXT,
        purpose TEXT,
        notes TEXT,
        lat REAL,
        lng REAL,
        FOREIGN KEY (customer_id) REFERENCES customers (id),
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Insert default data
    await _insertDefaultData(db);
  }

  Future<void> _insertDefaultData(Database db) async {
    // Insert default user
    await db.insert('users', {
      'name': 'Admin User',
      'email': 'admin@alpha.com',
      'phone': '9876543210',
      'password': 'admin123',
      'role': 'admin',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('users', {
      'name': 'Rahul Sharma',
      'email': 'rahul@alpha.com',
      'phone': '9876543211',
      'password': 'user123',
      'role': 'employee',
      'created_at': DateTime.now().toIso8601String(),
    });

    // Insert default vehicles
    await db.insert('vehicles', {
      'plate_number': 'MH-01-AB-1234',
      'model': 'Toyota Innova',
      'type': 'Van',
      'status': 'active',
      'current_lat': 19.0760,
      'current_lng': 72.8777,
      'fuel_level': 75,
      'last_updated': DateTime.now().toIso8601String(),
    });

    await db.insert('vehicles', {
      'plate_number': 'MH-02-CD-5678',
      'model': 'Maruti Ertiga',
      'type': 'Van',
      'status': 'active',
      'current_lat': 19.0760,
      'current_lng': 72.8777,
      'fuel_level': 90,
      'last_updated': DateTime.now().toIso8601String(),
    });

    // Insert default customers
    await db.insert('customers', {
      'name': 'John Doe',
      'email': 'john@example.com',
      'phone': '9876543212',
      'address': '123 Main Street, Mumbai',
      'gst_number': '27AABCU9603R1ZM',
      'type': 'customer',
      'status': 'active',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('customers', {
      'name': 'Jane Smith',
      'email': 'jane@example.com',
      'phone': '9876543213',
      'address': '456 Oak Avenue, Mumbai',
      'gst_number': '27AABCU9603R1ZN',
      'type': 'customer',
      'status': 'active',
      'created_at': DateTime.now().toIso8601String(),
    });

    // Insert default products
    await db.insert('products', {
      'name': 'Product A',
      'sku': 'SKU-001',
      'description': 'High quality product A',
      'price': 1500.0,
      'stock': 45,
      'category': 'Electronics',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('products', {
      'name': 'Product B',
      'sku': 'SKU-002',
      'description': 'Premium product B',
      'price': 2300.0,
      'stock': 12,
      'category': 'Electronics',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('products', {
      'name': 'Product C',
      'sku': 'SKU-003',
      'description': 'Standard product C',
      'price': 950.0,
      'stock': 78,
      'category': 'Electronics',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // Generic CRUD operations
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> query(String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<int> update(String table, Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
