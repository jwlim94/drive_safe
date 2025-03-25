import 'package:drive_safe/src/features/user/presentation/controllers/update_user_drive_streak_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_last_drive_streak_at_controller.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
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

bool userMetGoalInTime(int goalCompleteByTime, int currentTime) {
  if (currentTime >= goalCompleteByTime) {
    //User did not meet goal in time
    return false;
  } else {
    return true;
  }
}

Future<void> updateDriveStreak(Ref ref, int nowTimeStamp) async {
  final currentUser = ref.read(currentUserStateProvider);
  if (currentUser == null) return;

  final lastDriveStreakAt = currentUser.lastDriveStreakAt;

  // First-time streak tracking.
  if (lastDriveStreakAt == null) {
    await ref
        .read(updateUserDriveStreakControllerProvider.notifier)
        .updateUserDriveStreak();
    await ref
        .read(updateUserLastDriveStreakAtControllerProvider.notifier)
        .updateUserLastDriveStreakAt();
    return;
  }

  final lastStreakDate = DateTime.fromMillisecondsSinceEpoch(lastDriveStreakAt);
  final lastRecordedDate =
      DateTime(lastStreakDate.year, lastStreakDate.month, lastStreakDate.day);

  final nowDateTime = DateTime.fromMillisecondsSinceEpoch(nowTimeStamp);
  final todayDate =
      DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day);

  // Ensure users only get their streak once per day
  if (todayDate.isAtSameMomentAs(lastRecordedDate)) {
    return; // Streak already updated today, no need to update again.
  }

  // Update streak since it's a new day.
  await ref
      .read(updateUserDriveStreakControllerProvider.notifier)
      .updateUserDriveStreak();
  await ref
      .read(updateUserLastDriveStreakAtControllerProvider.notifier)
      .updateUserLastDriveStreakAt();
}

@riverpod
DailyGoalService dailyGoalService(Ref ref) {
  return DailyGoalService(ref);
}
