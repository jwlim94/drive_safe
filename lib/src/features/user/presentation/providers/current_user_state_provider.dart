import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_state_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserState extends _$CurrentUserState {
  @override
  User? build() {
    return null;
  }

  void setUser(User user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  void updateUserGoal(int dailyGoal) {
    state?.userGoal = dailyGoal;
  }

  void updateUserGoalByTime(int goalByTime) {
    state?.goalCompleteByTime = goalByTime;
  }
}
