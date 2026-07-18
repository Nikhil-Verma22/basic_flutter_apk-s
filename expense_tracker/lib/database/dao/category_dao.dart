import 'package:floor/floor.dart';
import '../entity/category.dart';

@dao
abstract class CategoryDao {
  @Query('SELECT * FROM Category')
  Stream<List<Category>> findAllCategories();

  @Query('SELECT * FROM Category WHERE id = :id')
  Stream<Category?> findCategoryById(int id);

  @insert
  Future<int> insertCategory(Category category);

  @delete
  Future<void> deleteCategory(Category category);
}
