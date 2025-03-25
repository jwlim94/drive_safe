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
    final updatedUser = await ref
        .read(usersRepositoryProvider)
        .updateUserEnduranceMinutes(userId, enduranceMinutes);

    state = AsyncData(updatedUser);
  }
}
