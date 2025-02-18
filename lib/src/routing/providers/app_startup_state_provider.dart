import 'package:drive_safe/src/features/car/presentation/controllers/cache_current_car_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/cache_current_user_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_startup_state_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<void> appStartupState(Ref ref) async {
  // ? Temporary delay to simulate preloading tasks and show the splash screen
  await Future.delayed(const Duration(seconds: 1));

  ref.onDispose(() {
    ref.invalidate(cacheCurrentUserControllerProvider);
    ref.invalidate(cacheCurrentCarControllerProvider);
  });

  await ref
      .watch(cacheCurrentUserControllerProvider.notifier)
      .cacheCurrentUser();
  await ref.watch(cacheCurrentCarControllerProvider.notifier).cacheCurrentCar();
}
