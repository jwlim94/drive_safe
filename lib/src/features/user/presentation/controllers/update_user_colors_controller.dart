import 'package:drive_safe/src/features/user/data/users_repository.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_user_colors_controller.g.dart';

@riverpod
class UpdateUserColorsController extends _$UpdateUserColorsController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> updateUserColors(int primaryColor, int secondaryColor) async {
    final usersRepository = ref.read(usersRepositoryProvider);
    final currentUser = ref.read(currentUserStateProvider);

    if (currentUser == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => usersRepository.updateUserColors(
        currentUser.id,
        primaryColor,
        secondaryColor,
      ),
    );

    if (!state.hasError) {
      final user = state.value as User;
      ref.read(currentUserStateProvider.notifier).setUser(user);
    }
  }
}
