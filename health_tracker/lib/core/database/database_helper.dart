import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DailyData {
  final String date;
  final int steps;
  final int waterMl;

  DailyData({required this.date, this.steps = 0, this.waterMl = 0});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'steps': steps,
      'water_ml': waterMl,
    };
  }

  factory DailyData.fromMap(Map<String, dynamic> map) {
    return DailyData(
      date: map['date'],
      steps: map['steps'],
      waterMl: map['water_ml'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('health_tracker.db');
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

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE daily_data (
  date TEXT PRIMARY KEY,
  steps INTEGER NOT NULL,
  water_ml INTEGER NOT NULL
)
''');
  }

  Future<DailyData> getDailyData(String date) async {
    final db = await instance.database;
    final maps = await db.query(
      'daily_data',
      where: 'date = ?',
      whereArgs: [date],
    );

    if (maps.isNotEmpty) {
      return DailyData.fromMap(maps.first);
    } else {
      return DailyData(date: date);
    }
  }

  Future<void> updateSteps(String date, int steps) async {
    final db = await instance.database;
    final current = await getDailyData(date);
    
    await db.insert(
      'daily_data',
      current.toMap()..['steps'] = steps,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addWater(String date, int amountMl) async {
    final db = await instance.database;
    final current = await getDailyData(date);
    
    await db.insert(
      'daily_data',
      current.toMap()..['water_ml'] = current.waterMl + amountMl,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DailyData>> getWeeklyData() async {
    final db = await instance.database;
    final maps = await db.query(
      'daily_data',
      orderBy: 'date DESC',
      limit: 7,
    );
    return maps.map((e) => DailyData.fromMap(e)).toList();
  }
}
