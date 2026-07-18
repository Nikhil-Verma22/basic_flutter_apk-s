import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/activity_provider.dart';
import '../../providers/goals_provider.dart';
import '../widgets/glass_container.dart';
import '../../core/theme/app_theme.dart';
import 'stats_overview.dart';
import 'set_goals_screen.dart';
import 'settings_screen.dart';

class HomeDashboard extends ConsumerWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(activityProvider);
    final profile = ref.watch(userProfileProvider);

    // Calculate dynamic values
    double calories = activity.steps * profile.weightKg * 0.0005;
    double progressSteps = (activity.steps / profile.stepGoal).clamp(0.0, 1.0);
    double progressWater = (activity.waterMl / profile.waterGoalMl).clamp(0.0, 1.0);
    double progressCal = (calories / (profile.stepGoal * profile.weightKg * 0.0005)).clamp(0.0, 1.0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppTheme.background.withOpacity(0.4),
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.transparent),
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.monitor_heart, color: AppTheme.primary),
            const SizedBox(width: 8),
            Text('Pulse Tracker', style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w900,
            )),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background blobs for glassmorphism effect
          Positioned(
            top: 100, right: -50,
            child: Container(width: 250, height: 250, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x33b1feda))),
          ),
          Positioned(
            bottom: 200, left: -50,
            child: Container(width: 250, height: 250, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x337bd1fa))),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
              child: Column(
                spacing: 24,
                children: [
                   _buildSummaryGlass(context, activity.steps, profile.stepGoal, calories, progressSteps, progressCal),
                   _buildGridStats(context, ref, activity.waterMl, profile.waterGoalMl, calories),
                ],
              ),
            ),
          ),
          _buildBottomNavbar(context),
        ],
      ),
    );
  }

  Widget _buildSummaryGlass(BuildContext context, int steps, int stepGoal, double calories, double progressSteps, double progressCal) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("TODAY'S SUMMARY", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryContainer]).createShader(bounds),
            child: Text(
              steps >= stepGoal ? 'Excellent' : 'Good Progress',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 32),
          _buildProgressBar(context, 'Steps', Icons.directions_run, AppTheme.primary, '$steps / $stepGoal', progressSteps),
          const SizedBox(height: 16),
          _buildProgressBar(context, 'Calories', Icons.local_fire_department, AppTheme.secondary, '${calories.toInt()} kcal', progressCal),
          const SizedBox(height: 16),
          _buildProgressBar(context, 'Active', Icons.accessibility_new, Colors.yellow, '${(steps / 100).toInt()} min', progressSteps), // Mock active 100 steps = 1 min
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, String label, IconData icon, Color color, String valueLabel, double progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 4),
                Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.onSurfaceVariant)),
              ],
            ),
            Text(valueLabel, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppTheme.onSurface)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 12, width: double.infinity,
          decoration: BoxDecoration(color: AppTheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(6)),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridStats(BuildContext context, WidgetRef ref, int waterMl, int waterGoalMl, double calories) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildGridItem(
          context, 
          icon: Icons.water_drop, 
          iconColor: AppTheme.secondary, 
          value: '${(waterMl / 1000).toStringAsFixed(1)}L', 
          label: 'Hydration',
          onTap: () => ref.read(activityProvider.notifier).addWater(250), // Add 250ml manually
        ),
        _buildGridItem(
          context, 
          icon: Icons.local_fire_department, 
          iconColor: AppTheme.error, 
          value: calories.toInt().toString(), 
          label: 'Calories',
        ),
      ],
    );
  }

  Widget _buildGridItem(BuildContext context, {required IconData icon, required Color iconColor, required String value, required String label, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: iconColor, size: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900)),
                Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.onSurfaceVariant)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavbar(BuildContext context) {
    return Positioned(
      bottom: 24, left: 16, right: 16,
      child: GlassContainer(
        blur: 40,
        borderRadius: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, Icons.speed, 'Status', isActive: true, onTap: () {}),
            _navItem(context, Icons.bar_chart, 'Stats', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatsOverview()))),
            _navItem(context, Icons.flag, 'Goals', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SetGoalsScreen()))),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, {bool isActive = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? AppTheme.primary : AppTheme.onSurfaceVariant, size: 28),
          const SizedBox(height: 4),
          Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: isActive ? AppTheme.primary : AppTheme.onSurfaceVariant, fontSize: 8)),
        ],
      ),
    );
  }
}
