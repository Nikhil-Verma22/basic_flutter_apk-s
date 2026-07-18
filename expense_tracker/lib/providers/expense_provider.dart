import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/app_database.dart';
import '../database/entity/category.dart';
import '../database/entity/expense.dart';

enum FilterType { today, weekly, monthly, yearly, all, custom }
enum SortOrder { ascending, descending }

class ExpenseProvider with ChangeNotifier {
  final AppDatabase database;
  
  List<Expense> _expenses = [];
  List<Category> _categories = [];
  FilterType _currentFilter = FilterType.monthly;
  DateTime? _selectedDate;
  int? _selectedCategoryId; // null means "All"
  SortOrder _sortOrder = SortOrder.descending; // Default: newest first
  SortOrder _categorySortOrder = SortOrder.descending; // For category breakdown
  double? _dailySpendingLimit;
  SharedPreferences? _prefs;

  ExpenseProvider(this.database) {
    _initCategories();
    _fetchExpenses(); // Initial fetch
    _loadDailyLimit();
  }

  List<Expense> get expenses => _expenses;
  List<Category> get categories => _categories;
  FilterType get currentFilter => _currentFilter;
  int? get selectedCategoryId => _selectedCategoryId;
  SortOrder get sortOrder => _sortOrder;
  SortOrder get categorySortOrder => _categorySortOrder;
  double? get dailySpendingLimit => _dailySpendingLimit;

  Future<void> _initCategories() async {
    database.categoryDao.findAllCategories().listen((cats) async {
       if (cats.isEmpty) {
          // Default categories
          final food = Category(name: 'Food', icon: 'restaurant', color: 0xFF9A3669); // tertiary
          final shopping = Category(name: 'Shopping', icon: 'shopping_bag', color: 0xFF6A46AE); // secondary
          final travel = Category(name: 'Travel', icon: 'commute', color: 0xFFA092FF); // primaryContainer
          await database.categoryDao.insertCategory(food);
          await database.categoryDao.insertCategory(shopping);
          await database.categoryDao.insertCategory(travel);
       } else {
          _categories = cats;
          notifyListeners();
       }
    });
  }

  DateTime? get selectedDate => _selectedDate;

  void _fetchExpenses() {
    final now = DateTime.now();
    DateTime start, end;
    
    if (_currentFilter == FilterType.today) {
      start = DateTime(now.year, now.month, now.day);
      end = start.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    } else if (_currentFilter == FilterType.weekly) {
      start = now.subtract(Duration(days: now.weekday - 1));
      start = DateTime(start.year, start.month, start.day);
      end = start.add(const Duration(days: 7)).subtract(const Duration(milliseconds: 1));
    } else if (_currentFilter == FilterType.monthly) {
      start = DateTime(now.year, now.month, 1);
      end = DateTime(now.year, now.month + 1, 1).subtract(const Duration(milliseconds: 1));
    } else if (_currentFilter == FilterType.yearly) {
      start = DateTime(now.year, 1, 1);
      end = DateTime(now.year + 1, 1, 1).subtract(const Duration(milliseconds: 1));
    } else if (_currentFilter == FilterType.all) {
      // All time - from beginning to now
      start = DateTime(2000, 1, 1); // Far past date
      end = now;
    } else {
      // Custom filter
      if (_selectedDate == null) {
        start = DateTime(now.year, now.month, now.day);
      } else {
        start = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
      }
      end = start.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    }

    if (_selectedCategoryId != null) {
        database.expenseDao.findExpensesByCategory(_selectedCategoryId!).listen((exps) {
           _expenses = exps.where((e) => e.date >= start.millisecondsSinceEpoch && e.date <= end.millisecondsSinceEpoch).toList();
           _sortExpenses();
           notifyListeners();
        });
    } else {
        database.expenseDao.findExpensesBetweenDates(start.millisecondsSinceEpoch, end.millisecondsSinceEpoch).listen((exps) {
           _expenses = exps;
           _sortExpenses();
           notifyListeners();
        });
    }
  }

  void _sortExpenses() {
    if (_sortOrder == SortOrder.ascending) {
      _expenses.sort((a, b) => a.date.compareTo(b.date));
    } else {
      _expenses.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  void toggleSortOrder() {
    _sortOrder = _sortOrder == SortOrder.ascending ? SortOrder.descending : SortOrder.ascending;
    _sortExpenses();
    notifyListeners();
  }

  void toggleCategorySortOrder() {
    _categorySortOrder = _categorySortOrder == SortOrder.ascending ? SortOrder.descending : SortOrder.ascending;
    notifyListeners();
  }

  // Get sorted category totals for insights page
  List<MapEntry<int, double>> getSortedCategoryTotals() {
    final Map<int, double> categoryTotals = {};
    for (final expense in _expenses) {
      categoryTotals[expense.categoryId] = (categoryTotals[expense.categoryId] ?? 0) + expense.amount;
    }

    final entries = categoryTotals.entries.toList();
    
    if (_categorySortOrder == SortOrder.ascending) {
      entries.sort((a, b) => a.value.compareTo(b.value)); // Low to high spending
    } else {
      entries.sort((a, b) => b.value.compareTo(a.value)); // High to low spending
    }

    return entries;
  }

  void setFilter(FilterType type) {
    _currentFilter = type;
    if (type != FilterType.custom) {
      _selectedDate = null;
    }
    _fetchExpenses();
  }

  void setCustomDateFilter(DateTime date) {
    _currentFilter = FilterType.custom;
    _selectedDate = date;
    _fetchExpenses();
  }

  void setCategoryFilter(int? categoryId) {
    _selectedCategoryId = categoryId;
    _fetchExpenses();
  }

  Future<void> addExpense(Expense expense) async {
    await database.expenseDao.insertExpense(expense);
  }

  Future<void> addCategory(Category category) async {
    await database.categoryDao.insertCategory(category);
  }

  Future<void> deleteCategory(Category category) async {
    await database.categoryDao.deleteCategory(category);
  }
  
  // Check if category has expenses
  Future<bool> categoryHasExpenses(int categoryId) async {
    final expenses = await database.expenseDao.findExpensesByCategory(categoryId).first;
    return expenses.isNotEmpty;
  }
  
  // Get total spending (all time)
  Future<double> getTotalSpendingAllTime() async {
    final allExpenses = await database.expenseDao.findExpensesBetweenDates(
      DateTime(2000, 1, 1).millisecondsSinceEpoch,
      DateTime.now().millisecondsSinceEpoch,
    ).first;
    return allExpenses.fold<double>(0, (sum, e) => sum + e.amount);
  }
  
  // Get number of activities (total expenses count - all time)
  Future<int> getActivityCountAllTime() async {
    final allExpenses = await database.expenseDao.findExpensesBetweenDates(
      DateTime(2000, 1, 1).millisecondsSinceEpoch,
      DateTime.now().millisecondsSinceEpoch,
    ).first;
    return allExpenses.length;
  }
  
  // Get number of categories
  int get categoryCount {
    return _categories.length;
  }

  // Daily spending limit methods
  Future<void> _loadDailyLimit() async {
    _prefs = await SharedPreferences.getInstance();
    final limit = _prefs?.getDouble('daily_spending_limit');
    if (limit != null) {
      _dailySpendingLimit = limit;
      notifyListeners();
    }
  }

  Future<void> setDailySpendingLimit(double? limit) async {
    _dailySpendingLimit = limit;
    _prefs ??= await SharedPreferences.getInstance();
    
    if (limit == null) {
      await _prefs?.remove('daily_spending_limit');
    } else {
      await _prefs?.setDouble('daily_spending_limit', limit);
    }
    
    notifyListeners();
  }

  // Get today's spending
  double getTodaySpending() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    
    return _expenses
        .where((e) => e.date >= start.millisecondsSinceEpoch && e.date <= end.millisecondsSinceEpoch)
        .fold<double>(0, (sum, e) => sum + e.amount);
  }

  // Get spending status color
  Color getSpendingStatusColor() {
    if (_dailySpendingLimit == null || _dailySpendingLimit == 0) {
      return Colors.grey;
    }

    final todaySpending = getTodaySpending();
    final ratio = todaySpending / _dailySpendingLimit!;

    if (ratio < 0.4) {
      return Colors.green;
    } else if (ratio < 0.95) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // Check if limit exceeded
  bool isLimitExceeded() {
    if (_dailySpendingLimit == null || _dailySpendingLimit == 0) {
      return false;
    }
    return getTodaySpending() >= _dailySpendingLimit!;
  }
}
