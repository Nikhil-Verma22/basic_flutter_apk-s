import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final int stepGoal;
  final int waterGoalMl;
  final double heightCm;
  final double weightKg;
  final bool onboardingComplete;

  UserProfile({
    required this.stepGoal,
    required this.waterGoalMl,
    required this.heightCm,
    required this.weightKg,
    required this.onboardingComplete,
  });

  UserProfile copyWith({
    int? stepGoal,
    int? waterGoalMl,
    double? heightCm,
    double? weightKg,
    bool? onboardingComplete,
  }) {
    return UserProfile(
      stepGoal: stepGoal ?? this.stepGoal,
      waterGoalMl: waterGoalMl ?? this.waterGoalMl,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }
}

class UserProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return UserProfile(
      stepGoal: prefs.getInt('stepGoal') ?? 6000,
      waterGoalMl: prefs.getInt('waterGoalMl') ?? 2500,
      heightCm: prefs.getDouble('heightCm') ?? 170.0,
      weightKg: prefs.getDouble('weightKg') ?? 70.0,
      onboardingComplete: prefs.getBool('onboardingComplete') ?? false,
    );
  }

  Future<void> updateGoals({int? stepGoal, int? waterGoalMl}) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final updated = state.copyWith(stepGoal: stepGoal, waterGoalMl: waterGoalMl);
    if (stepGoal != null) await prefs.setInt('stepGoal', stepGoal);
    if (waterGoalMl != null) await prefs.setInt('waterGoalMl', waterGoalMl);
    state = updated;
  }

  Future<void> updateProfile({double? heightCm, double? weightKg}) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final updated = state.copyWith(heightCm: heightCm, weightKg: weightKg);
    if (heightCm != null) await prefs.setDouble('heightCm', heightCm);
    if (weightKg != null) await prefs.setDouble('weightKg', weightKg);
    state = updated;
  }

  Future<void> completeOnboarding() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('onboardingComplete', true);
    state = state.copyWith(onboardingComplete: true);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize this in ProviderScope');
});

final userProfileProvider = NotifierProvider<UserProfileNotifier, UserProfile>(() {
  return UserProfileNotifier();
});
