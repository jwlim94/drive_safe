import 'package:drive_safe/src/shared/constants/enums.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_type_state_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthTypeState extends _$AuthTypeState {
  @override
  AuthType build() {
    return AuthType.guest;
  }

  void setAuthType(AuthType authType) {
    state = authType;
  }
}
