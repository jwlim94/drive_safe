import 'package:drive_safe/src/routing/providers/go_router_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouterState = ref.watch(goRouterStateProvider);

    return MaterialApp.router(
      routerConfig: goRouterState,
      theme: ThemeData(
        fontFamily: Strings.roboto,
        scaffoldBackgroundColor: AppColors.customBlack,
      ),
    );
  }
}
