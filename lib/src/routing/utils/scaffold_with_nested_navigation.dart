import 'package:drive_safe/src/routing/providers/scaffold_with_nested_navigation_visibility_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNestedNavigation extends ConsumerWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNavBarVisible = ref.watch(bottomNavBarVisibilityProvider);

    return Scaffold(
      body: Center(
        child: navigationShell,
      ),
      bottomNavigationBar: isNavBarVisible
          ? Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.customGray,
                      width: 3,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: BottomNavigationBar(
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.leaderboard_outlined),
                        label: 'Leaderboard',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.garage_outlined),
                        label: 'Game',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_2_outlined),
                        label: 'Profile',
                      ),
                    ],
                    currentIndex: navigationShell.currentIndex,
                    enableFeedback: false,
                    type: BottomNavigationBarType.fixed,
                    selectedLabelStyle: TextStyles.bodySmall,
                    unselectedLabelStyle: TextStyles.bodySmall,
                    selectedItemColor: AppColors.customBlue,
                    unselectedItemColor: AppColors.customWhite,
                    backgroundColor: AppColors.customBlack,
                    onTap: _goBranch,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
