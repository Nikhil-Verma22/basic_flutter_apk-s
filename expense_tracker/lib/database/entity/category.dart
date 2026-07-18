import 'package:floor/floor.dart';

@entity
class Category {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  final String name;
  final String icon; 
  final int color; 

  Category({this.id, required this.name, required this.icon, required this.color});
}
