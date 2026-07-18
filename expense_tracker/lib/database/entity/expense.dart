import 'package:floor/floor.dart';

@entity
class Expense {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  final String description;
  final double amount;
  final int date; 
  final int categoryId;
  
  Expense({
    this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.categoryId,
  });
}
