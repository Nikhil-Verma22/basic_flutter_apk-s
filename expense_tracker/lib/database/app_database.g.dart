// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CategoryDao? _categoryDaoInstance;

  ExpenseDao? _expenseDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Category` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `icon` TEXT NOT NULL, `color` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Expense` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `description` TEXT NOT NULL, `amount` REAL NOT NULL, `date` INTEGER NOT NULL, `categoryId` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  ExpenseDao get expenseDao {
    return _expenseDaoInstance ??= _$ExpenseDao(database, changeListener);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _categoryInsertionAdapter = InsertionAdapter(
            database,
            'Category',
            (Category item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'icon': item.icon,
                  'color': item.color
                },
            changeListener),
        _categoryDeletionAdapter = DeletionAdapter(
            database,
            'Category',
            ['id'],
            (Category item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'icon': item.icon,
                  'color': item.color
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Category> _categoryInsertionAdapter;

  final DeletionAdapter<Category> _categoryDeletionAdapter;

  @override
  Stream<List<Category>> findAllCategories() {
    return _queryAdapter.queryListStream('SELECT * FROM Category',
        mapper: (Map<String, Object?> row) => Category(
            id: row['id'] as int?,
            name: row['name'] as String,
            icon: row['icon'] as String,
            color: row['color'] as int),
        queryableName: 'Category',
        isView: false);
  }

  @override
  Stream<Category?> findCategoryById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Category WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Category(
            id: row['id'] as int?,
            name: row['name'] as String,
            icon: row['icon'] as String,
            color: row['color'] as int),
        arguments: [id],
        queryableName: 'Category',
        isView: false);
  }

  @override
  Future<int> insertCategory(Category category) {
    return _categoryInsertionAdapter.insertAndReturnId(
        category, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCategory(Category category) async {
    await _categoryDeletionAdapter.delete(category);
  }
}

class _$ExpenseDao extends ExpenseDao {
  _$ExpenseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _expenseInsertionAdapter = InsertionAdapter(
            database,
            'Expense',
            (Expense item) => <String, Object?>{
                  'id': item.id,
                  'description': item.description,
                  'amount': item.amount,
                  'date': item.date,
                  'categoryId': item.categoryId
                },
            changeListener),
        _expenseDeletionAdapter = DeletionAdapter(
            database,
            'Expense',
            ['id'],
            (Expense item) => <String, Object?>{
                  'id': item.id,
                  'description': item.description,
                  'amount': item.amount,
                  'date': item.date,
                  'categoryId': item.categoryId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Expense> _expenseInsertionAdapter;

  final DeletionAdapter<Expense> _expenseDeletionAdapter;

  @override
  Stream<List<Expense>> findAllExpenses() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Expense ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            description: row['description'] as String,
            amount: row['amount'] as double,
            date: row['date'] as int,
            categoryId: row['categoryId'] as int),
        queryableName: 'Expense',
        isView: false);
  }

  @override
  Stream<List<Expense>> findExpensesBetweenDates(
    int startDate,
    int endDate,
  ) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Expense WHERE date >= ?1 AND date <= ?2 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            description: row['description'] as String,
            amount: row['amount'] as double,
            date: row['date'] as int,
            categoryId: row['categoryId'] as int),
        arguments: [startDate, endDate],
        queryableName: 'Expense',
        isView: false);
  }

  @override
  Stream<List<Expense>> findExpensesByCategory(int categoryId) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Expense WHERE categoryId = ?1 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            description: row['description'] as String,
            amount: row['amount'] as double,
            date: row['date'] as int,
            categoryId: row['categoryId'] as int),
        arguments: [categoryId],
        queryableName: 'Expense',
        isView: false);
  }

  @override
  Future<int> insertExpense(Expense expense) {
    return _expenseInsertionAdapter.insertAndReturnId(
        expense, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteExpense(Expense expense) {
    return _expenseDeletionAdapter.deleteAndReturnChangedRows(expense);
  }
}
