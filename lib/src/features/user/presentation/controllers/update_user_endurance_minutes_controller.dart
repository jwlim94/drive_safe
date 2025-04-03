import 'package:drive_safe/src/features/home/presentation/providers/session_provider.dart';
import 'package:drive_safe/src/features/user/data/users_repository.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_user_endurance_minutes_controller.g.dart';

@riverpod
class UpdateUserEnduranceMinutesController
    extends _$UpdateUserEnduranceMinutesController {
  @override
  FutureOr<User?> build() => null;

  Future<void> updateUser(String userId, int enduranceSeconds) async {
    final repo = ref.read(usersRepositoryProvider);
    final currentUser = ref.watch(currentUserStateProvider);
    await repo.updateUserEnduranceMinutes(userId, enduranceSeconds);
    final badgeThresholds = [30, 60, 90, 120, 150, 180];
    final currentBadges = currentUser?.badges ?? [];

    for (final threshold in badgeThresholds) {
      final badgeKey = 'endurance_$threshold';
      if (enduranceSeconds >= threshold * 60 &&
          !currentBadges.contains(badgeKey)) {
        currentBadges.add(badgeKey);
        // update the notifier
        ref.read(sessionNotifierProvider.notifier).addSessionBadges(badgeKey);
      }
    }

    if (currentBadges != []) {
      // update in Firestore
      await repo.updateUserBadges(userId, currentBadges);
    }

    state = AsyncData(
        currentUser?.copyWith(badges: currentBadges)); // optional update
  }
}
