import 'package:drive_safe/src/features/car/domain/car_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'car_data_state_provider.g.dart';

@Riverpod(keepAlive: true)
class CarDataState extends _$CarDataState {
  @override
  CarData build() {
    return CarData();
  }

  void setId(String id) {
    state = CarData(
      id: id,
      type: state.type,
      description: state.description,
    );
  }

  void setType(String type) {
    state = CarData(
      id: state.id,
      type: type,
      description: state.description,
    );
  }

  void setDescription(String description) {
    state = CarData(
      id: state.id,
      type: state.type,
      description: description,
    );
  }
}
