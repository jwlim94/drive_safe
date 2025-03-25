import 'package:drive_safe/src/features/home/application/daily_goal_service.dart';
import 'package:drive_safe/src/features/user/data/users_repository.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_daily_goal_controller.g.dart';

@riverpod
class UpdateDailyGoalController extends _$UpdateDailyGoalController {
  @override
  Future<void> build(int userGoal, int? sessionTime) async {
    final currentUser = ref.read(currentUserStateProvider);
    final userRepository = ref.read(usersRepositoryProvider);
    final nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
    final int oneDayFromNow =
        DateTime.now().add(const Duration(hours: 36)).millisecondsSinceEpoch;

    Map<String, bool> isDailyGoalComplete = {
      'IsCompleted': false,
      'IsGoalSet': false,
      'IsExcessGoalTime': false
    };

    if (currentUser != null) {
      if (sessionTime != null) {
        isDailyGoalComplete =
            checkDailyGoalComplete(sessionTime, currentUser.userGoal);
      }

      // User Daily Goal Set and Completed without excess time
      if (isDailyGoalComplete['IsCompleted'] == true &&
          isDailyGoalComplete['IsGoalSet'] == true &&
          isDailyGoalComplete['IsExcessGoalTime'] == false) {
        final timeExceededGoal = currentUser.userGoal - sessionTime! - 1;
        await userRepository.updateUserDailyGoal(
            timeExceededGoal, currentUser.id);

        // Check if goal time has expired
        if (!userMetGoalInTime(currentUser.goalCompleteByTime, nowTimeStamp)) {
          await userRepository.resetGoalCompleteTime(currentUser.id);
          await userRepository.updateUserDailyGoal(0, currentUser.id);
          ref.read(currentUserStateProvider.notifier).updateUserGoalByTime(0);
          ref.read(currentUserStateProvider.notifier).updateUserGoal(0);
        } else {
          updateDriveStreak(ref, nowTimeStamp);
        }
      }

      // User Daily Goal Set and Completed with excess time
      if (isDailyGoalComplete['IsCompleted'] == true &&
          isDailyGoalComplete['IsGoalSet'] == true &&
          isDailyGoalComplete['IsExcessGoalTime'] == true) {
        final timeExceededGoal = currentUser.userGoal - sessionTime!;
        await userRepository.updateUserDailyGoal(
            timeExceededGoal, currentUser.id);

        // Check if goal time has expired
        if (!userMetGoalInTime(currentUser.goalCompleteByTime, nowTimeStamp)) {
          await userRepository.resetGoalCompleteTime(currentUser.id);
          await userRepository.updateUserDailyGoal(0, currentUser.id);
          ref.read(currentUserStateProvider.notifier).updateUserGoalByTime(0);
          ref.read(currentUserStateProvider.notifier).updateUserGoal(0);
        } else {
          updateDriveStreak(ref, nowTimeStamp);
        }
      }

      // User Daily Goal Set and NOT Completed
      else if (isDailyGoalComplete['IsCompleted'] == false &&
          isDailyGoalComplete['IsGoalSet'] == true &&
          isDailyGoalComplete['IsExcessGoalTime'] == false) {
        final goalTimeRemaining = currentUser.userGoal - sessionTime!;

        if (!userMetGoalInTime(currentUser.goalCompleteByTime, nowTimeStamp)) {
          await userRepository.updateUserDailyGoal(0, currentUser.id);
          await userRepository.updateUserDriveStreak(currentUser.id, 0);
          ref.read(currentUserStateProvider.notifier).updateUserGoalByTime(0);
          ref.read(currentUserStateProvider.notifier).updateUserGoal(0);
        } else {
          await userRepository.updateUserDailyGoal(
              goalTimeRemaining, currentUser.id);
        }
      }

      // User Daily Goal NOT Set and NOT Completed
      else if (isDailyGoalComplete['IsCompleted'] == false &&
          isDailyGoalComplete['IsGoalSet'] == false &&
          isDailyGoalComplete['IsExcessGoalTime'] == false) {
        await userRepository.updateGoalCompleteTime(
            currentUser.id, oneDayFromNow);
        ref
            .read(currentUserStateProvider.notifier)
            .updateUserGoalByTime(oneDayFromNow);
        await userRepository.updateUserDailyGoal(userGoal, currentUser.id);
        ref.read(currentUserStateProvider.notifier).updateUserGoal(userGoal);
      }
    }
  }
}
