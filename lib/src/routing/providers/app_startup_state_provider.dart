import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_startup_state_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<void> appStartupState(Ref ref) async {
  ref.onDispose(() {
    // Add providers to invalidate here... (such as shared preferences)
  });
  return;

  // Add invalidated providers to watch here...
}
