import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';
import '../database/entity/expense.dart';
import '../database/entity/category.dart';
import 'statistics_screen.dart';
import 'add_expense_screen.dart';
import 'manage_categories_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.grid_view, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Text(
              'Journal',
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showDailyLimitDialog(context, provider),
            icon: Icon(
              Icons.notifications_outlined,
              color: provider.getSpendingStatusColor(),
            ),
          ),
        ],
      ),
      body: [
        _buildHomeContent(context, provider),
        const StatisticsScreen(),
        const ProfileScreen(),
      ][_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddExpenseScreen(),
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'FEED',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: 'INSIGHTS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }

  void _showDailyLimitDialog(BuildContext context, ExpenseProvider provider) {
    final controller = TextEditingController(
      text: provider.dailySpendingLimit?.toStringAsFixed(0) ?? '',
    );
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily Spending Limit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set your daily spending limit to track your expenses',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Daily Limit (rs)',
                hintText: 'Enter amount',
                prefixIcon: const Icon(Icons.currency_rupee),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (provider.dailySpendingLimit != null) ...[
              Text(
                'Today\'s Spending: ${provider.getTodaySpending().toStringAsFixed(0)}rs',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: provider.dailySpendingLimit! > 0
                    ? (provider.getTodaySpending() / provider.dailySpendingLimit!).clamp(0.0, 1.0)
                    : 0,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  provider.getSpendingStatusColor(),
                ),
                minHeight: 8,
              ),
            ],
          ],
        ),
        actions: [
          if (provider.dailySpendingLimit != null)
            TextButton(
              onPressed: () {
                provider.setDailySpendingLimit(null);
                Navigator.pop(context);
              },
              child: const Text('Clear'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final limit = double.tryParse(controller.text);
              if (limit != null && limit > 0) {
                provider.setDailySpendingLimit(limit);
                
                // Check if limit exceeded and show notification
                if (provider.isLimitExceeded()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('⚠️ Daily spending limit exceeded!'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, ExpenseProvider provider) {
    final theme = Theme.of(context);
    final totalSpent = provider.expenses.fold<double>(0, (sum, e) => sum + e.amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Overview', style: theme.textTheme.labelSmall),
                   Text('Expenses', style: theme.textTheme.displayLarge),
                ],
              ),
              IconButton.filled(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: provider.selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    provider.setCustomDateFilter(date);
                  }
                },
                icon: const Icon(Icons.calendar_month),
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Timeframe Filters
          _buildTimeframeFilters(provider),
          
          const SizedBox(height: 20),
          
          // Category Filters
          _buildCategoryFilters(provider),
          
          const SizedBox(height: 30),
          
          // Recent Activity Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: theme.textTheme.displayMedium?.copyWith(fontSize: 18),
              ),
              IconButton(
                onPressed: () => provider.toggleSortOrder(),
                icon: Icon(
                  provider.sortOrder == SortOrder.ascending
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                ),
                tooltip: provider.sortOrder == SortOrder.ascending
                    ? 'Oldest first'
                    : 'Newest first',
              ),
            ],
          ),
          
          const SizedBox(height: 10),
          
          // Expenses List
          if (provider.expenses.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'No transactions found',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.expenses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final expense = provider.expenses[index];
                return _buildExpenseTile(context, expense, provider);
              },
            ),
            
          const SizedBox(height: 30),
          
          // Spending Chart Summary Card
          _buildSummaryCard(context, totalSpent),
          
          const SizedBox(height: 100), // Padding for FAB
        ],
      ),
    );
  }

  Widget _buildTimeframeFilters(ExpenseProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: FilterType.values.map((type) {
          final isSelected = provider.currentFilter == type;
          String label = type.name.toUpperCase();
          
          if (type == FilterType.custom && provider.selectedDate != null) {
            label = DateFormat('MMM dd').format(provider.selectedDate!);
          } else if (type == FilterType.custom) {
            return const SizedBox.shrink(); // Hide custom chip if no date selected
          }

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => provider.setFilter(type),
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryFilters(ExpenseProvider provider) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // "All" Chip
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManageCategoriesScreen()),
              );
            },
            icon: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.add),
            ),
          ),
          const SizedBox(width: 12),
          _buildCategoryChip(
            null,
            'All',
            Icons.dashboard,
            provider.selectedCategoryId == null,
            () => provider.setCategoryFilter(null),
          ),
          const SizedBox(width: 12),
          ...provider.categories.map((cat) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _buildCategoryChip(
                cat.color,
                cat.name,
                _getIconData(cat.icon),
                provider.selectedCategoryId == cat.id,
                () => provider.setCategoryFilter(cat.id),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    int? color,
    String name,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Colors.white
                  : (color != null ? Color(color) : theme.colorScheme.primary),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseTile(BuildContext context, Expense expense, ExpenseProvider provider) {
    final theme = Theme.of(context);
    final category = provider.categories.firstWhere(
      (c) => c.id == expense.categoryId,
      orElse: () => Category(name: 'Other', icon: 'help', color: 0xFF9E9E9E),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(category.color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              _getIconData(category.icon),
              color: Color(category.color),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.description,
                  style: theme.textTheme.displayMedium?.copyWith(fontSize: 16),
                ),
                Text(
                  DateFormat('MMM dd, hh:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(expense.date),
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '- ${expense.amount.toStringAsFixed(0)}rs',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: 16,
                  color: theme.colorScheme.error,
                ),
              ),
              Text(
                category.name.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, double totalSpent) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monthly Spending'.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    NumberFormat('#,###').format(totalSpent),
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'rs',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Status',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              const Text(
                'On Track',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Icon(
              Icons.analytics,
              size: 60,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
        ],
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
      case 'add': return Icons.add;
      default: return Icons.help_outline;
    }
  }
}
