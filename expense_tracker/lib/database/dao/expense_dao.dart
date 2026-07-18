import 'package:floor/floor.dart';
import '../entity/expense.dart';

@dao
abstract class ExpenseDao {
  @Query('SELECT * FROM Expense ORDER BY date DESC')
  Stream<List<Expense>> findAllExpenses();

  @Query('SELECT * FROM Expense WHERE date >= :startDate AND date <= :endDate ORDER BY date DESC')
  Stream<List<Expense>> findExpensesBetweenDates(int startDate, int endDate);

  @Query('SELECT * FROM Expense WHERE categoryId = :categoryId ORDER BY date DESC')
  Stream<List<Expense>> findExpensesByCategory(int categoryId);

  @insert
  Future<int> insertExpense(Expense expense);

  @delete
  Future<int> deleteExpense(Expense expense);
}
