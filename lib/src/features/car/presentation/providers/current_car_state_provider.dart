import 'package:drive_safe/src/features/car/domain/car.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_car_state_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentCarState extends _$CurrentCarState {
  @override
  Car? build() {
    return null;
  }

  void setCar(Car car) {
    state = car;
  }

  void clearCar() {
    state = null;
  }
}
