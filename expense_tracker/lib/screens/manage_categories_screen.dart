import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../database/entity/category.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  final _nameController = TextEditingController();
  int _selectedColor = 0xFF5944CA;
  String _selectedIcon = 'restaurant';

  final List<Map<String, dynamic>> _iconOptions = [
    {'icon': Icons.restaurant, 'name': 'restaurant'},
    {'icon': Icons.shopping_bag, 'name': 'shopping_bag'},
    {'icon': Icons.commute, 'name': 'commute'},
    {'icon': Icons.lunch_dining, 'name': 'lunch_dining'},
    {'icon': Icons.checkroom, 'name': 'checkroom'},
    {'icon': Icons.smart_display, 'name': 'smart_display'},
    {'icon': Icons.payments, 'name': 'payments'},
    {'icon': Icons.home, 'name': 'home'},
    {'icon': Icons.fitness_center, 'name': 'fitness_center'},
    {'icon': Icons.medical_services, 'name': 'medical_services'},
  ];

  final List<int> _colorOptions = [
    0xFF5944CA, // Primary
    0xFF9A3669, // Tertiary
    0xFF006A60, // Teal
    0xFFB02F21, // Red
    0xFF6A46AE, // Purple
    0xFF515E7D, // Blue Gray
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: provider.categories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final cat = provider.categories[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(cat.color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_getIconData(cat.icon), color: Color(cat.color), size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(cat.name, style: theme.textTheme.displayMedium?.copyWith(fontSize: 16)),
                ),
                IconButton(
                  onPressed: () async {
                    // Check if category has expenses
                    final hasExpenses = await provider.categoryHasExpenses(cat.id!);
                    
                    if (!context.mounted) return;
                    
                    if (hasExpenses) {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Cannot delete category with existing expenses'),
                          backgroundColor: theme.colorScheme.error,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      // Show confirmation dialog
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Category?'),
                          content: Text('Are you sure you want to delete "${cat.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.error,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirmed == true && context.mounted) {
                        await provider.deleteCategory(cat);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Category deleted successfully'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    }
                  },
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCategoryDialog(context, provider),
        label: const Text('Add Category'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, ExpenseProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New Category', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Category Name',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Select Icon', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _iconOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final opt = _iconOptions[index];
                    final isSelected = _selectedIcon == opt['name'];
                    return IconButton(
                      onPressed: () => setDialogState(() => _selectedIcon = opt['name']),
                      icon: Icon(opt['icon']),
                      style: IconButton.styleFrom(
                        backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                        foregroundColor: isSelected ? Colors.white : null,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text('Select Color', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colorOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final color = _colorOptions[index];
                    final isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () => setDialogState(() => _selectedColor = color),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(color),
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                          boxShadow: isSelected ? [BoxShadow(color: Color(color).withOpacity(0.4), blurRadius: 8)] : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      provider.addCategory(Category(
                        name: _nameController.text,
                        icon: _selectedIcon,
                        color: _selectedColor,
                      ));
                      _nameController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create Category'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'restaurant': return Icons.restaurant;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'commute': return Icons.commute;
      case 'lunch_dining': return Icons.lunch_dining;
      case 'checkroom': return Icons.checkroom;
      case 'smart_display': return Icons.smart_display;
      case 'payments': return Icons.payments;
      case 'home': return Icons.home;
      case 'fitness_center': return Icons.fitness_center;
      case 'medical_services': return Icons.medical_services;
      default: return Icons.help_outline;
    }
  }
}
