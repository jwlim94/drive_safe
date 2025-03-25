import 'package:drive_safe/src/features/user/data/users_repository.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_user_endurance_minutes_controller.g.dart';

@riverpod
class UpdateUserEnduranceMinutesController
    extends _$UpdateUserEnduranceMinutesController {
  @override
  FutureOr<User?> build() => null;

  Future<void> updateUser(String userId, int enduranceMinutes) async {
    final repo = ref.read(usersRepositoryProvider);
    final updatedUser =
        await repo.updateUserEnduranceMinutes(userId, enduranceMinutes);

    final badgeThresholds = [30, 60, 90, 120, 150, 180];
    final currentBadges = updatedUser.badges ?? [];

    for (final threshold in badgeThresholds) {
      final badgeKey = 'endurance_$threshold';
      if (enduranceMinutes >= threshold && !currentBadges.contains(badgeKey)) {
        currentBadges.add(badgeKey);
      }
    }

    // update in Firestore
    await repo.updateUserBadges(userId, currentBadges);

    state = AsyncData(
        updatedUser.copyWith(badges: currentBadges)); // optional update
  }
}
