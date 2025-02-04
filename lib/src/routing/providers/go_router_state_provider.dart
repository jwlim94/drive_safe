import 'package:drive_safe/src/features/authentication/data/auth_repository.dart';
import 'package:drive_safe/src/features/garage/presentation/garage_screen.dart';
import 'package:drive_safe/src/features/home/presentation/drivingstatus_end_screen.dart';
import 'package:drive_safe/src/features/home/presentation/drivingstatus_screen.dart';
import 'package:drive_safe/src/features/home/presentation/home_screen.dart';
import 'package:drive_safe/src/features/leaderboard/presentation/leaderboard_screen.dart';
import 'package:drive_safe/src/features/onboarding/presentation/onboarding_accountconnection.dart';
import 'package:drive_safe/src/features/onboarding/presentation/onboarding_basicinfo.dart';
import 'package:drive_safe/src/features/onboarding/presentation/onboarding_vehicleselection.dart';
import 'package:drive_safe/src/features/user/presentation/profile_screen.dart';
import 'package:drive_safe/src/routing/app_startup.dart';
import 'package:drive_safe/src/routing/providers/app_startup_state_provider.dart';
import 'package:drive_safe/src/routing/utils/extra_codec.dart';
import 'package:drive_safe/src/routing/utils/go_router_refresh_stream.dart';
import 'package:drive_safe/src/routing/utils/scaffold_with_nested_navigation.dart';
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
    initialLocation: '/onboardingBasicInfo',
    extraCodec: const ExtraCodec(),
    debugLogDiagnostics: true,
    navigatorKey: Keys.rootNavigatorKey,
    redirect: (context, state) {
      if (appStartupState.isLoading || appStartupState.hasError) {
        return '/startup';
      }
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
        path: '/onboardingBasicInfo',
        name: AppRoute.onboardingBasicInfo.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreenBasicInfo(),
        ),
      ),
      GoRoute(
        path: '/onboardingVehicleSelection',
        name: AppRoute.onboardingVehicleSelection.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreenVehicleSelection(),
        ),
      ),
      GoRoute(
        path: '/onboardingAccountConnection',
        name: AppRoute.onboardingAccountConnection.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingAccountconnection(),
        ),
      ),
      // route to DrivingStatusEnd
      GoRoute(
        path: '/driving_status_end',
        name: AppRoute.drivingStatusEnd.name,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: DrivingStatusEndScreen(),
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: Keys.rootNavigatorKey,
        pageBuilder: (context, state, navigationShell) => NoTransitionPage(
          child: ScaffoldWithNestedNavigation(
            navigationShell: navigationShell,
          ),
        ),
        branches: [
          StatefulShellBranch(
            navigatorKey: Keys.homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                name: AppRoute.home.name,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: HomeScreen(),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'driving_status',
                    name: AppRoute.drivingStatus.name,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage(
                        child: DrivingStatusScreen(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: Keys.leaderboardNavigatorKey,
            routes: [
              GoRoute(
                path: '/leaderboard',
                name: AppRoute.leaderboard.name,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: LeaderboardScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: Keys.garageNavigatorKey,
            routes: [
              GoRoute(
                path: '/garage',
                name: AppRoute.garage.name,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: GarageScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: Keys.profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: AppRoute.profile.name,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: ProfileScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
