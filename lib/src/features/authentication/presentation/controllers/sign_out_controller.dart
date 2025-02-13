import 'package:drive_safe/src/features/authentication/data/auth_repository.dart';
import 'package:drive_safe/src/features/car/presentation/providers/current_car_state_provider.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out_controller.g.dart';

@riverpod
class SignOutController extends _$SignOutController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> signOut() {
    ref.read(currentUserStateProvider.notifier).clearUser();
    ref.read(currentCarStateProvider.notifier).clearCar();
    return ref.read(authRepositoryProvider).signOut();
  }
}
