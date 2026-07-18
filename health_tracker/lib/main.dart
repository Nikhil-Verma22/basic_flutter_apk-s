import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'providers/goals_provider.dart';
import 'ui/screens/home_dashboard.dart';
import 'ui/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Init storage and notifications
  final prefs = await SharedPreferences.getInstance();
  await NotificationService().init();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const PulseApp(),
    ),
  );
}

class PulseApp extends ConsumerWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    
    return MaterialApp(
      title: 'Pulse Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: profile.onboardingComplete ? const HomeDashboard() : const OnboardingScreen(),
    );
  }
}
