import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'database/app_database.dart';
import 'providers/expense_provider.dart';
import 'theme.dart';
import 'screens/home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database factory based on platform
  if (kIsWeb) {
    sqflite.databaseFactory = databaseFactoryFfiWeb;
    debugPrint('[INIT] Web database factory initialized');
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Initialize FFI for desktop platforms
    sqfliteFfiInit();
    sqflite.databaseFactory = databaseFactoryFfi;
    debugPrint('[INIT] Desktop database factory initialized');
  }

  final dbFuture = _initializeDatabase();

  runApp(
    FutureBuilder<AppDatabase>(
      future: dbFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'Failed to initialize database: ${snapshot.error}\n\n'
                    'Try clearing your browser cache or restarting the app.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => ExpenseProvider(snapshot.data!),
              ),
            ],
            child: const ExpenseTrackerApp(),
          );
        }

        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    ),
  );
}

Future<AppDatabase> _initializeDatabase() async {
  try {
    debugPrint('[DB] kIsWeb=$kIsWeb — starting database init...');
    final db = await createDatabase();
    debugPrint('[DB] SUCCESS — database ready');
    return db;
  } catch (e, stack) {
    debugPrint('[DB] FAILED: $e');
    debugPrint('[DB] $stack');
    rethrow;
  }
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
