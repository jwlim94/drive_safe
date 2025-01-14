import 'package:drive_safe/src/routing/async_states/app_startup_error_state_widget.dart';
import 'package:drive_safe/src/routing/async_states/app_startup_loading_state_widget.dart';
import 'package:drive_safe/src/routing/providers/app_startup_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStartup extends ConsumerWidget {
  const AppStartup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupStateProvider);

    return appStartupState.when(
      loading: () => const AppStartupLoadingStateWidget(),
      data: (_) => const SizedBox.shrink(),
      error: (e, st) => AppStartupErrorStateWidget(
        message: e.toString(),
        onRetry: () => ref.invalidate(appStartupStateProvider),
      ),
    );
  }
}
