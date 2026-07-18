import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);
    final theme = Theme.of(context);

    return FutureBuilder<Map<String, dynamic>>(
      future: _getProfileStats(provider),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = snapshot.data!;
        final totalSpending = stats['totalSpending'] as double;
        final activityCount = stats['activityCount'] as int;
        final categoryCount = stats['categoryCount'] as int;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account',
                style: theme.textTheme.labelSmall,
              ),
              Text(
                'Profile',
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 40),
              
              // Profile Avatar
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primaryContainer,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // User Name
              Center(
                child: Text(
                  'User',
                  style: theme.textTheme.displayMedium?.copyWith(fontSize: 24),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Statistics Cards
              Text(
                'Statistics',
                style: theme.textTheme.displayMedium?.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 20),
              
              // Total Spending Card
              _buildStatCard(
                context,
                icon: Icons.account_balance_wallet,
                title: 'Total Spending',
                value: '${totalSpending.toStringAsFixed(0)}rs',
                color: theme.colorScheme.primary,
              ),
              
              const SizedBox(height: 16),
              
              // Number of Activities Card
              _buildStatCard(
                context,
                icon: Icons.receipt_long,
                title: 'Number of Activities',
                value: '$activityCount',
                color: theme.colorScheme.tertiary,
              ),
              
              const SizedBox(height: 16),
              
              // Number of Categories Card
              _buildStatCard(
                context,
                icon: Icons.category,
                title: 'Number of Categories',
                value: '$categoryCount',
                color: theme.colorScheme.secondary,
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getProfileStats(ExpenseProvider provider) async {
    final totalSpending = await provider.getTotalSpendingAllTime();
    final activityCount = await provider.getActivityCountAllTime();
    final categoryCount = provider.categoryCount;

    return {
      'totalSpending': totalSpending,
      'activityCount': activityCount,
      'categoryCount': categoryCount,
    };
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 28,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
