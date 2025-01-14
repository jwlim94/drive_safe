import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loading_state_provider.g.dart';

@Riverpod(keepAlive: true)
class LoadingState extends _$LoadingState {
  @override
  bool build() {
    return false;
  }

  void setLoadingState(bool loadingState) {
    state = loadingState;
  }
}
