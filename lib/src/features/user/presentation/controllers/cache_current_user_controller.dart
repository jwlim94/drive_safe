import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:drive_safe/src/features/authentication/data/auth_repository.dart';
import 'package:drive_safe/src/features/user/data/users_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drive_safe/src/features/user/domain/user.dart' as model;

part 'cache_current_user_controller.g.dart';

@Riverpod(keepAlive: true)
class CacheCurrentUserController extends _$CacheCurrentUserController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> cacheCurrentUser() async {
    final usersRepository = ref.read(usersRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    firebase.User? currentUser = authRepository.currentUser;

    if (currentUser == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => usersRepository.fetchUser(currentUser.uid));

    if (state.hasError) return FirebaseAuth.instance.signOut();

    if (state.hasValue) {
      final user = state.value as model.User?;
      if (user == null) return FirebaseAuth.instance.signOut();

      ref.read(currentUserStateProvider.notifier).setUser(user);
    }
  }
}
