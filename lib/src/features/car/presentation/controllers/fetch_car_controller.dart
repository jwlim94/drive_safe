import 'package:drive_safe/src/features/car/data/cars_repository.dart';
import 'package:drive_safe/src/features/car/domain/car.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_car_controller.g.dart';

@riverpod
class FetchCarController extends _$FetchCarController {
  @override
  FutureOr<Car?> build(String carId) {
    return ref.read(carsRepositoryProvider).fetchCar(carId);
  }
}
