import 'package:drive_safe/src/features/home/presentation/providers/session_provider.dart';
import 'package:drive_safe/src/features/user/data/users_repository.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_drive_streak_badge_controller.g.dart';

@riverpod
class UpdateDriveStreakBadgeController
    extends _$UpdateDriveStreakBadgeController {
  @override
  FutureOr<User?> build() => null;

  Future<void> updateUserDriveStreakBadge(User currentUser) async {
    final repo = ref.read(usersRepositoryProvider);
    final currentUser = ref.watch(currentUserStateProvider);
    final badgeThresholds = [10, 20, 50, 100, 250, 365];
    final currentBadges = currentUser?.badges ?? [];

    if (currentUser != null) {
      for (final threshold in badgeThresholds) {
        final badgeKey = 'hotstreak_$threshold';
        if (currentUser.driveStreak >= threshold &&
            !currentBadges.contains(badgeKey)) {
          currentBadges.add(badgeKey);
          // update the notifier
          ref.read(sessionNotifierProvider.notifier).addSessionBadges(badgeKey);
        }
      }

      // Firestore에 badge 업데이트
      await repo.updateUserBadges(currentUser.id, currentBadges);
    }

    // controller 상태 갱신
    state = AsyncData(currentUser?.copyWith(badges: currentBadges));
  }
}
