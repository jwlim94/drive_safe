import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    //required this.navigationShell,
  }) : super(key: key ?? const ValueKey('CustomAppBar'));

  // final StatefulNavigationShell navigationShell;

  // void _goBranch(int index) {
  //   navigationShell.goBranch(
  //     index,
  //     // A common pattern when using bottom navigation bars is to support
  //     // navigating to the initial location when tapping the item that is
  //     // already active. This example demonstrates how to support this behavior,
  //     // using the initialLocation parameter of goBranch.
  //     initialLocation: index == navigationShell.currentIndex,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.customBlack,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              const Center(
                child: Text(
                  "Vehicle\nSelection",
                  style: TextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                height: 5,
                width: 75,
                decoration: const BoxDecoration(color: AppColors.customPink),
              )
            ],
          ),
          Column(
            children: [
              const Text("Getting\nStarted", style: TextStyles.bodyMedium),
              const SizedBox(
                height: 12,
              ),
              Container(
                height: 5,
                width: 60,
                decoration: const BoxDecoration(color: AppColors.customPink),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
