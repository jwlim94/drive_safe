import 'package:drive_safe/src/features/user/data/users_repository.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_user_controller.g.dart';

@riverpod
class DeleteUserController extends _$DeleteUserController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> deleteUser() async {
    final usersRepository = ref.read(usersRepositoryProvider);
    final currentUser = ref.read(currentUserStateProvider);

    if (currentUser == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => usersRepository.deleteUser(currentUser.id),
    );
  }
}
