// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DbHelper {
//   static final DbHelper _instance = DbHelper._init();
//   static Database? _database;

//   DbHelper._init();

//   factory DbHelper() => _instance;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('tasks.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//     CREATE TABLE tasks(
//       id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
//       title TEXT,
//       category TEXT,
//       date TEXT,
//       time TEXT,
//       reminder TEXT,
//       createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
//     )
//     ''');
//   }

//   Future<int> insert(Map<String, dynamic> data) async {
//     final db = await database;
//     return await db.insert('tasks', data);
//   }

//   Future<List<Map<String, dynamic>>> queryAllRows() async {
//     final db = await database;
//     return await db.query('tasks', orderBy: 'id DESC');
//   }
// }
