import 'package:drive_safe/src/features/authentication/data/auth_repository.dart';
import 'package:drive_safe/src/features/car/data/cars_repository.dart';
import 'package:drive_safe/src/features/car/domain/car.dart';
import 'package:drive_safe/src/features/car/presentation/providers/current_car_state_provider.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cache_current_car_controller.g.dart';

@Riverpod(keepAlive: true)
class CacheCurrentCarController extends _$CacheCurrentCarController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> cacheCurrentCar() async {
    final carsRepository = ref.read(carsRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);

    firebase.User? authUser = authRepository.currentUser;
    if (authUser == null) return;

    final currentUser = ref.read(currentUserStateProvider);
    if (currentUser == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => carsRepository.fetchCar(currentUser.carId),
    );

    if (state.hasError) return FirebaseAuth.instance.signOut();

    if (state.hasValue) {
      final car = state.value as Car;
      ref.read(currentCarStateProvider.notifier).setCar(car);
    }
  }
}
