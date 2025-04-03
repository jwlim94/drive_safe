import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drive_safe/src/features/user/data/users_repository.dart';

part 'update_user_required_focus_time_in_seconds_controller.g.dart';

@riverpod
class UpdateUserRequiredFocusTimeInSecondsController
    extends _$UpdateUserRequiredFocusTimeInSecondsController {
  @override
  FutureOr<void> build() {}

  Future<void> updateUserRequiredFocusTimeInSeconds(
      String userId, int requiredFocusTimeInSeconds) async {
    final usersRepository = ref.read(usersRepositoryProvider);
    final currentUser = ref.read(currentUserStateProvider);

    if (currentUser == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => usersRepository.updateUserRequiredFocusTimeInSeconds(
        currentUser.id,
        requiredFocusTimeInSeconds,
      ),
    );

    if (!state.hasError) {
      final user = state.value as User;
      ref.read(currentUserStateProvider.notifier).setUser(user);
    }
  }
}
