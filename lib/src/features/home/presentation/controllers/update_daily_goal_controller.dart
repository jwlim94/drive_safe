import 'package:drive_safe/src/features/home/application/daily_goal_service.dart';
import 'package:drive_safe/src/features/user/data/users_repository.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_daily_goal_controller.g.dart';

@riverpod
class UpdateDailyGoalController extends _$UpdateDailyGoalController {
  @override
  FutureOr<void> build(int userGoal, int? sessionTime) {
    final currentUser = ref.read(currentUserStateProvider);
    final userRepository = ref.read(usersRepositoryProvider);
    Map<String, bool> isDailyGoalComplete = {
      'IsCompleted': false,
      'IsGoalSet': false
    };

    if (currentUser != null) {
      if (sessionTime != null) {
        isDailyGoalComplete =
            checkDailyGoalComplete(sessionTime, currentUser.userGoal);
      }

      //User Daily Goal Set and Completed
      if (isDailyGoalComplete['IsCompleted'] == true &&
          isDailyGoalComplete['IsGoalSet'] == true) {
        final timeExceededGoal = currentUser.userGoal - sessionTime!;
        userRepository.updateUserDailyGoal(timeExceededGoal, currentUser.id);
      }
      //User Daily Goal Set and NOT Completed
      else if (isDailyGoalComplete['IsCompleted'] == false &&
          isDailyGoalComplete['IsGoalSet'] == true) {
        final goalTimeRemaining = currentUser.userGoal - sessionTime!;
        userRepository.updateUserDailyGoal(goalTimeRemaining, currentUser.id);
      }
      //User Daily Goal NOT Set and NOT Completed
      else if (isDailyGoalComplete['IsCompleted'] == false &&
          isDailyGoalComplete['IsGoalSet'] == false) {
        userRepository.updateUserDailyGoal(userGoal, currentUser.id);
      }
    }
  }
}
