import 'package:drive_safe/src/features/user/data/users_repository.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_drive_streak_and_badge_controller.g.dart';

@riverpod
class UpdateDriveStreakAndBadgeController
    extends _$UpdateDriveStreakAndBadgeController {
  @override
  FutureOr<User?> build() => null;

  Future<void> updateUserDriveStreakAndAwardBadge(User currentUser) async {
    final repo = ref.read(usersRepositoryProvider);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final int? lastTimestamp = currentUser.lastDriveStreakAt;

    DateTime? lastDate;
    if (lastTimestamp != null) {
      lastDate = DateTime.fromMillisecondsSinceEpoch(lastTimestamp);
    }

    int newStreak = currentUser.driveStreak;

    if (lastDate == null || today.difference(lastDate).inDays > 1) {
      newStreak = 1;
    } else if (today.difference(lastDate).inDays == 1) {
      newStreak += 1;
    } // 오늘 이미 streak 찍혔으면 유지

    // Firestore에 driveStreak과 마지막 기록일자 저장
    await repo.updateUserDriveStreak(currentUser.id, newStreak);
    await repo.updateUserLastDriveStreakAt(
        currentUser.id, today.millisecondsSinceEpoch);

    // badge 체크
    final updatedUser = currentUser.copyWith(driveStreak: newStreak);
    final badgeThresholds = [10, 20, 50, 100, 250, 365];
    final currentBadges = List<String>.from(updatedUser.badges ?? []);

    for (final threshold in badgeThresholds) {
      final badgeKey = 'hotstreak_$threshold';
      if (newStreak >= threshold && !currentBadges.contains(badgeKey)) {
        currentBadges.add(badgeKey);
      }
    }

    // Firestore에 badge 업데이트
    await repo.updateUserBadges(currentUser.id, currentBadges);

    // controller 상태 갱신
    state = AsyncData(updatedUser.copyWith(badges: currentBadges));
  }
}
