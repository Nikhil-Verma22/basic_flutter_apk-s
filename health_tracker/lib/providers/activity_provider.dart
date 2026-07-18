import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedometer/pedometer.dart';
import 'package:intl/intl.dart';
import '../core/database/database_helper.dart';

// Provides the current day's data (Steps, Water, Calories)
class ActivityState {
  final int steps;
  final int waterMl;
  
  ActivityState({this.steps = 0, this.waterMl = 0});

  ActivityState copyWith({int? steps, int? waterMl}) {
    return ActivityState(
      steps: steps ?? this.steps,
      waterMl: waterMl ?? this.waterMl,
    );
  }
}

class ActivityNotifier extends Notifier<ActivityState> {
  @override
  ActivityState build() {
    _init();
    return ActivityState();
  }

  String get _today => DateFormat('yyyy-MM-dd').format(DateTime.now());
  
  int _initialPedoSteps = -1;

  Future<void> _init() async {
    final dailyData = await DatabaseHelper.instance.getDailyData(_today);
    state = ActivityState(steps: dailyData.steps, waterMl: dailyData.waterMl);
    
    // Listen to pedometer
    try {
      Pedometer.stepCountStream.listen((StepCount event) {
        _onStepCount(event);
      }, onError: (error) {
        print("Pedometer error: $error");
      }, cancelOnError: true);
    } catch (_) {
      // Permission denied or sensor not available
    }
  }

  void _onStepCount(StepCount event) {
    if (_initialPedoSteps == -1) {
      _initialPedoSteps = event.steps;
    }
    
    int newSteps = event.steps - _initialPedoSteps;
    if (newSteps > 0) {
      final totalToday = state.steps + newSteps;
      state = state.copyWith(steps: totalToday);
      _initialPedoSteps = event.steps; 
      DatabaseHelper.instance.updateSteps(_today, totalToday);
    }
  }

  Future<void> addWater(int amountMl) async {
    final newWater = state.waterMl + amountMl;
    state = state.copyWith(waterMl: newWater);
    await DatabaseHelper.instance.addWater(_today, amountMl);
  }
}

final activityProvider = NotifierProvider<ActivityNotifier, ActivityState>(() {
  return ActivityNotifier();
});
