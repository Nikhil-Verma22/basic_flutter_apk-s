import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'entity/category.dart';
import 'entity/expense.dart';
import 'dao/category_dao.dart';
import 'dao/expense_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [Category, Expense])
abstract class AppDatabase extends FloorDatabase {
  CategoryDao get categoryDao;
  ExpenseDao get expenseDao;
}

Future<AppDatabase> createDatabase() async {
  try {
    if (kIsWeb) {
      debugPrint('[DB] Creating in-memory database for web...');
      // For web, use in-memory database (data persists during session only)
      return await $FloorAppDatabase
          .inMemoryDatabaseBuilder()
          .addCallback(Callback(
            onCreate: (database, version) async {
              debugPrint('[DB] Database created successfully');
            },
          ))
          .build();
    } else {
      // For mobile and desktop, use persistent database
      debugPrint('[DB] Creating persistent database...');
      return await $FloorAppDatabase
          .databaseBuilder('expense_tracker.db')
          .build();
    }
  } catch (e) {
    debugPrint('[DB] Error creating database: $e');
    rethrow;
  }
}
