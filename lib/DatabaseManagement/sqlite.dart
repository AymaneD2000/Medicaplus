// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseManager {
//   int _index = 0;
//   int get index => _index;
//   //static final DatabaseManager instance = DatabaseManager._();
//   static Database? _database;
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     final path = await getDatabasesPath();
//     final databasePath = join(path, 'products.db');
//     return openDatabase(
//       databasePath,
//       version: 1,
//       onCreate: (db, version) async {
//         await createMedTable(db);
//         await createSendingBoxTable(db);
//       },
//     );
//   }

//   static const String med = "Med";
//   static const String amo = "Amo";

//   Future<void> createMedTable(Database db) async {
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $med (
//         dci Text PRIMARY KEY,
//         name TEXT NOT NULL,
//         dataruns INTEGER,
//         brightness REAL,
//         aspect_ratio_w REAL NOT NULL,
//         aspect_ratio_h REAL NOT NULL,
//         diagonal_mesurement REAL,
//         panel_pix_h INTEGER NOT NULL,
//         power_consumption_max TEXT,
//         resolution_height INTEGER,
//         resolution_width INTEGER,
//         resolution_size INTEGER,
//         panel_px_w INTEGER NOT NULL,
//         pixel_per_pouce REAL NOT NULL,
//         weigh_per_module REAL NOT NULL
//       )
//     ''');
//   }

//   Future<int> insertProduct(Product product) async {
//     final db = await database;
//     return await db.insert(productTable, product.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<List<Product>> getProduct() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query(productTable);
//     return List.from(maps).map((e) => Product.fromJson(e)).toList();
//   }

//   Future<int> updateProduct(Product product) async {
//     final db = await database;
//     return await db.update(productTable, product.toMap(),
//         where: 'id = ?', whereArgs: [product.id]);
//   }

//   Future<int> deleteProduct(Product product) async {
//     final db = await database;
//     return await db
//         .delete(productTable, where: 'id = ?', whereArgs: [product.id]);
//   }

//   Future<void> createSendingBoxTable(Database db) async {
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $sendingBoxTable (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         boxName TEXT NOT NULL,
//         npd INTEGER NOT NULL,
//         dbmp INTEGER NOT NULL,
//         tc REAL NOT NULL
//       )
//     ''');
//   }

//   Future<int> insertSendingBox(SendingBox sendingBox) async {
//     final db = await database;
//     return await db.insert(sendingBoxTable, sendingBox.toMap());
//   }

//   Future<List<SendingBox>> getSendingBox() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query(sendingBoxTable);
//     return List.from(maps).map((e) => SendingBox.fromJson(e)).toList();
//   }

//   Future<int> updateSendingBox(SendingBox sendingBox) async {
//     final db = await database;
//     return await db.update(sendingBoxTable, sendingBox.toMap(),
//         where: 'id = ?', whereArgs: [sendingBox.id]);
//   }

//   Future<int> deleteSendingBox(SendingBox sendingBox) async {
//     final db = await database;
//     return await db
//         .delete(sendingBoxTable, where: 'id = ?', whereArgs: [sendingBox.id]);
//   }
// }