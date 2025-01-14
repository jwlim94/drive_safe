import 'package:drive_safe/src/features/authentication/data/auth_repository.dart';
import 'package:drive_safe/src/onboarding_screen.dart';
import 'package:drive_safe/src/routing/app_startup.dart';
import 'package:drive_safe/src/routing/providers/app_startup_state_provider.dart';
import 'package:drive_safe/src/routing/utils/extra_codec.dart';
import 'package:drive_safe/src/routing/utils/go_router_refresh_stream.dart';
import 'package:drive_safe/src/shared/constants/enums.dart';
import 'package:drive_safe/src/shared/constants/keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_state_provider.g.dart';

@riverpod
GoRouter goRouterState(Ref ref) {
  final appStartupState = ref.watch(appStartupStateProvider);
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/onboarding',
    extraCodec: const ExtraCodec(),
    debugLogDiagnostics: true,
    navigatorKey: Keys.rootNavigatorKey,
    redirect: (context, state) {
      // Show splash screen while the app is initializing
      if (appStartupState.isLoading || appStartupState.hasError) {
        return '/startup';
      }

      // Add silently signin and signout redirects here...

      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/startup',
        name: AppRoute.startup.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AppStartup(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: AppRoute.onboarding.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreen(),
        ),
      ),
      // Add more routes here...
    ],
  );
}
