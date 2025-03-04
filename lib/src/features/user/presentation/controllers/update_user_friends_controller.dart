import 'package:drive_safe/src/features/user/data/users_repository.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_user_friends_controller.g.dart';

@riverpod
class UpdateUserFriendsController extends _$UpdateUserFriendsController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> updateUserFriends(String friendId, String action) async {
    final usersRepository = ref.read(usersRepositoryProvider);
    final currentUser = ref.read(currentUserStateProvider);

    if (currentUser == null) return;

    usersRepository.updateUserFriends(currentUser.id, friendId, action);

    ref.read(currentUserStateProvider.notifier).setUser(currentUser);
  }
}
