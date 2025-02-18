import 'package:drive_safe/src/features/car/data/cars_repository.dart';
import 'package:drive_safe/src/features/car/domain/car.dart';
import 'package:drive_safe/src/features/car/presentation/providers/current_car_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_car_type_controller.g.dart';

@riverpod
class UpdateCarTypeController extends _$UpdateCarTypeController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> updateCarType(String type) async {
    final carsRepository = ref.read(carsRepositoryProvider);
    final currentCar = ref.read(currentCarStateProvider);

    if (currentCar == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => carsRepository.updateCarType(
        currentCar.id,
        type,
      ),
    );

    if (!state.hasError) {
      final car = state.value as Car;
      ref.read(currentCarStateProvider.notifier).setCar(car);
    }
  }
}
