import 'package:drive_safe/src/features/user/data/users_repository.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
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

  Future<void> refreshAndSetUser() async {
    final authUser = fb.FirebaseAuth.instance.currentUser;
    if (authUser == null) return;

    final repo = ref.read(usersRepositoryProvider);
    final latestUser = await repo.fetchUser(authUser.uid);
    if (latestUser == null) return;

    final updatedBadges = List<String>.from(latestUser.badges ?? []);

    for (final threshold in [10, 20, 50, 100, 250, 365]) {
      final key = 'hotstreak_$threshold';
      if (latestUser.driveStreak >= threshold && !updatedBadges.contains(key)) {
        updatedBadges.add(key);
      }
    }

    for (final threshold in [30, 60, 90, 120, 150, 180]) {
      final key = 'endurance_$threshold';
      if (latestUser.enduranceMinutes >= threshold &&
          !updatedBadges.contains(key)) {
        updatedBadges.add(key);
      }
    }

    if (updatedBadges.length != (latestUser.badges?.length ?? 0)) {
      await repo.updateUserBadges(latestUser.id, updatedBadges);
    }

    state = latestUser.copyWith(badges: updatedBadges);
  }
}
