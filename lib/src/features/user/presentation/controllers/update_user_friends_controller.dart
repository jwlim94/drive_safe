import 'package:cloud_firestore/cloud_firestore.dart';
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

    state = const AsyncValue.loading();

    try {
      // Firestore의 friends 배열을 업데이트하는 코드 추가
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser.id);
      final userSnapshot = await userRef.get();

      if (!userSnapshot.exists) {
        throw Exception("User does not exist");
      }

      List<dynamic> friendsList = userSnapshot.data()?['friends'] ?? [];

      if (action == 'add' && !friendsList.contains(friendId)) {
        friendsList.add(friendId);
      } else if (action == 'remove') {
        friendsList.remove(friendId);
      }

      await userRef.update({'friends': friendsList}); // Firestore 업데이트

      // 기존 state 업데이트
      state = await AsyncValue.guard(
        () =>
            usersRepository.updateUserFriends(currentUser.id, friendId, action),
      );

      if (!state.hasError) {
        final user = state.value as User;
        ref.read(currentUserStateProvider.notifier).setUser(user);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
