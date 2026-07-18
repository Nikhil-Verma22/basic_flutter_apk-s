import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/goals_provider.dart';
import '../widgets/glass_container.dart';
import '../../core/theme/app_theme.dart';

class SetGoalsScreen extends ConsumerStatefulWidget {
  const SetGoalsScreen({super.key});

  @override
  ConsumerState<SetGoalsScreen> createState() => _SetGoalsScreenState();
}

class _SetGoalsScreenState extends ConsumerState<SetGoalsScreen> {
  late TextEditingController _stepsController;
  late TextEditingController _waterController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _stepsController = TextEditingController(text: profile.stepGoal.toString());
    _waterController = TextEditingController(text: profile.waterGoalMl.toString());
  }

  Future<void> _saveGoals() async {
    final steps = int.tryParse(_stepsController.text) ?? 6000;
    final water = int.tryParse(_waterController.text) ?? 2500;
    await ref.read(userProfileProvider.notifier).updateGoals(stepGoal: steps, waterGoalMl: water);
    if(mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Goals Updated successfully')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Set Goals', style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppTheme.primary,
          fontWeight: FontWeight.w900,
        )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.primary),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 200, right: -50,
            child: Container(width: 300, height: 300, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x337bd1fa))),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: GlassContainer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _stepsController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Daily Steps Goal',
                        labelStyle: const TextStyle(color: AppTheme.onSurfaceVariant),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.2)), borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppTheme.primary), borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.directions_run, color: AppTheme.primary),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _waterController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Daily Water Goal (ml)',
                        labelStyle: const TextStyle(color: AppTheme.onSurfaceVariant),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.2)), borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppTheme.primary), borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.water_drop, color: AppTheme.secondary),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: AppTheme.background,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _saveGoals,
                      child: const Text('Save Goals', style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
