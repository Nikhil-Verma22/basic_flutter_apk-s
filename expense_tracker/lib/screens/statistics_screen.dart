import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';
import '../database/entity/category.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);
    final theme = Theme.of(context);

    // Get sorted category totals
    final sortedCategoryTotals = provider.getSortedCategoryTotals();
    final totalAmount = sortedCategoryTotals.fold<double>(0, (sum, entry) => sum + entry.value);

    final sections = sortedCategoryTotals.map((entry) {
      final category = provider.categories.firstWhere(
        (c) => c.id == entry.key,
        orElse: () => Category(name: 'Other', icon: 'help', color: 0xFF9E9E9E),
      );
      final percentage = (entry.value / totalAmount) * 100;

      return PieChartSectionData(
        color: Color(category.color),
        value: entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analytics',
                    style: theme.textTheme.labelSmall,
                  ),
                  Text(
                    'Insights',
                    style: theme.textTheme.displayLarge,
                  ),
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
          
          const SizedBox(height: 24),
          
          // Total Spent Summary Card
          _buildTotalSpentCard(context, totalAmount),
          
          const SizedBox(height: 32),
          
          // Chart section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh.withOpacity(0.3),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                Text(
                  'Spending Distribution',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: sections.isEmpty
                      ? Center(
                          child: Text(
                            'No data found',
                            style: theme.textTheme.bodyMedium,
                          ),
                        )
                      : PieChart(
                          PieChartData(
                            sections: sections,
                            sectionsSpace: 4,
                            centerSpaceRadius: 40,
                          ),
                        ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Legend / Category Breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Breakdown',
                style: theme.textTheme.displayMedium?.copyWith(fontSize: 18),
              ),
              IconButton(
                onPressed: () => provider.toggleCategorySortOrder(),
                icon: Icon(
                  provider.categorySortOrder == SortOrder.ascending
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                ),
                tooltip: provider.categorySortOrder == SortOrder.ascending
                    ? 'Low to high spending'
                    : 'High to low spending',
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (sortedCategoryTotals.isEmpty)
             Center(child: Text('Add transactions to see breakdown', style: theme.textTheme.bodySmall))
          else
            ...sortedCategoryTotals.map((entry) {
              final category = provider.categories.firstWhere(
                (c) => c.id == entry.key,
                orElse: () => Category(name: 'Other', icon: 'help', color: 0xFF9E9E9E),
              );
              return _buildBreakdownItem(context, category, entry.value, totalAmount);
            }).toList(),
          
          const SizedBox(height: 120), // Padding
        ],
      ),
    );
  }

  Widget _buildTimeframeFilters(ExpenseProvider provider) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
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
                  selectedColor: theme.colorScheme.primary,
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
      },
    );
  }

  Widget _buildTotalSpentCard(BuildContext context, double total) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL SPENDING',
            style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            '${total.toStringAsFixed(0)}rs',
            style: theme.textTheme.displayLarge?.copyWith(color: Colors.white, fontSize: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(BuildContext context, Category category, double amount, double total) {
    final theme = Theme.of(context);
    final percentage = (amount / total) * 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(category.color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(category.icon),
                  color: Color(category.color),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}% of budget',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                '${amount.toStringAsFixed(0)}rs',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: amount / total,
              backgroundColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(Color(category.color)),
              minHeight: 6,
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
      case 'home': return Icons.home;
      case 'fitness_center': return Icons.fitness_center;
      case 'medical_services': return Icons.medical_services;
      default: return Icons.help_outline;
    }
  }
}
