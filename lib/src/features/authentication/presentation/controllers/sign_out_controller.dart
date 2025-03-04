import 'package:drive_safe/src/features/authentication/data/auth_repository.dart';
import 'package:drive_safe/src/features/authentication/presentation/providers/auth_user_data_state_provider.dart';
import 'package:drive_safe/src/features/car/presentation/providers/car_data_state_provider.dart';
import 'package:drive_safe/src/features/car/presentation/providers/current_car_state_provider.dart';
import 'package:drive_safe/src/features/leaderboard/presentation/providers/current_league_state_provider.dart';
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
    ref.read(currentLeagueStateProvider.notifier).clearLeague();

    ref.read(authUserDataStateProvider.notifier).clear();
    ref.read(carDataStateProvider.notifier).clear();

    return ref.read(authRepositoryProvider).signOut();
  }
}
