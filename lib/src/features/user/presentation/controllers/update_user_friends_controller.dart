import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/src/features/user/data/users_repository.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_user_friends_controller.g.dart';

@riverpod
class UpdateUserFriendsController extends _$UpdateUserFriendsController {
  @override
  FutureOr<void> build() {
    // No operation needed
  }

  Future<void> updateUserFriends(String friendId, String action) async {
    final usersRepository = ref.read(usersRepositoryProvider);
    final currentUser = ref.read(currentUserStateProvider);

    if (currentUser == null) return;

    state = const AsyncValue.loading();

    try {
      // Firestore reference
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser.id);
      final userSnapshot = await userRef.get();

      if (!userSnapshot.exists) {
        throw Exception("User does not exist");
      }

      List<dynamic> friendsList = userSnapshot.data()?['friends'] ?? [];

      if (action == 'add') {
        if (!friendsList.contains(friendId)) {
          friendsList.add(friendId);
        } else {
          throw Exception("Friend already added.");
        }
      } else if (action == 'remove') {
        friendsList.remove(friendId);
      }

      // ✅ Firestore update before state change
      await userRef.update({'friends': friendsList});

      // ✅ Update Riverpod state properly
      final updatedUser = await usersRepository.fetchUser(currentUser.id);
      if (updatedUser == null) {
        throw Exception("Failed to fetch updated user.");
      }
      ref.read(currentUserStateProvider.notifier).setUser(updatedUser);

      state = AsyncValue.data(null); // ✅ No extra Future completion
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception("Failed to update friend: ${e.toString()}");
    }
  }
}
