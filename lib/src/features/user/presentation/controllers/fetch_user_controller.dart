import 'package:drive_safe/src/features/user/data/users_repository.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_user_controller.g.dart';

@riverpod
class FetchUserController extends _$FetchUserController {
  @override
  FutureOr<User?> build(String userId) async {
    return ref.read(usersRepositoryProvider).fetchUser(userId);
  }
}
