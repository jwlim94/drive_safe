import 'package:drive_safe/src/features/authentication/domain/auth_user_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_user_data_state_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthUserDataState extends _$AuthUserDataState {
  @override
  AuthUserData build() {
    return AuthUserData();
  }

  void setId(String id) {
    state = AuthUserData(
      id: id,
      name: state.name,
      age: state.age,
      carId: state.carId,
      email: state.email,
      password: state.password,
    );
  }

  void setName(String name) {
    state = AuthUserData(
      id: state.id,
      name: name,
      age: state.age,
      carId: state.carId,
      email: state.email,
      password: state.password,
    );
  }

  void setAge(int age) {
    state = AuthUserData(
      id: state.id,
      name: state.name,
      age: age,
      carId: state.carId,
      email: state.email,
      password: state.password,
    );
  }

  void setCarId(String id) {
    state = AuthUserData(
      id: state.id,
      name: state.name,
      age: state.age,
      carId: id,
      email: state.email,
      password: state.password,
    );
  }

  void setEmail(String email) {
    state = AuthUserData(
      id: state.id,
      name: state.name,
      age: state.age,
      carId: state.carId,
      email: email,
      password: state.password,
    );
  }

  void setPassword(String password) {
    state = AuthUserData(
      id: state.id,
      name: state.name,
      age: state.age,
      carId: state.carId,
      email: state.email,
      password: password,
    );
  }
}
