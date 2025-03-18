import 'package:drive_safe/src/features/user/data/users_repository.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_daily_goal_controller.g.dart';

@riverpod
class UpdateDailyGoalController extends _$UpdateDailyGoalController {
  @override
  FutureOr<void> build(int dailyGoal) {
    final currentUser = ref.read(currentUserStateProvider);
    final userRepository = ref.read(usersRepositoryProvider);
    //TODO: update user daily goal according to time..if user goal is negative, then they have exceeded their goal for the day.
    final isDailyGoalMet = true;

    if (currentUser != null) {
      if (currentUser.userGoal != 0 && isDailyGoalMet == false) {
        userRepository.updateUserDailyGoal(0, currentUser.id, 'Reset');
      } else if (currentUser.userGoal == 0 && isDailyGoalMet == true) {
        userRepository.updateUserDailyGoal(0, currentUser.id, 'Complete');
      } else {
        userRepository.updateUserDailyGoal(dailyGoal, currentUser.id, 'Set');
      }
    }
  }
}
