import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_goal_service.g.dart';

class DailyGoalService {
  const DailyGoalService(this.ref);
  final Ref ref;
}

Map<String, bool> checkDailyGoalComplete(int sessionTime, int currentUserGoal) {
  if (currentUserGoal == 0) {
    return {
      'IsCompleted': false,
      'IsGoalSet': false,
      'IsExcessGoalTime': false,
    };
  }

  if (sessionTime > currentUserGoal) {
    return {
      'IsCompleted': true,
      'IsGoalSet': true,
      'IsExcessGoalTime': true,
    };
  } else if (sessionTime == currentUserGoal) {
    return {
      'IsCompleted': true,
      'IsGoalSet': true,
      'IsExcessGoalTime': false,
    };
  } else {
    return {
      'IsCompleted': false,
      'IsGoalSet': true,
      'IsExcessGoalTime': false,
    };
  }
}

@riverpod
DailyGoalService dailyGoalService(Ref ref) {
  return DailyGoalService(ref);
}
