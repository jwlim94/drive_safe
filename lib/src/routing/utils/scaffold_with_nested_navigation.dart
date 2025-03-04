import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: Align(
          alignment: Alignment.topCenter,
          child: SvgPicture.asset(
            'assets/images/checkered_flag.svg',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Center(
        child: navigationShell,
      ),
      bottomNavigationBar: Theme(
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
                  label: 'Garage',
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
      ),
    );
  }
}
