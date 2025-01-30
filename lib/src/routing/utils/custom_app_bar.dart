import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomAppBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key ?? const ValueKey('CustomAppBar'));

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarState extends State<CustomAppBar> {
  void navigateToPage(int index) {
    widget.onItemTapped(index); //update parent widget state
    switch (index) {
      case 0:
        context.go('/onboardingBasicInfo');
        break;
      case 1:
        context.go('/onboardingVehicleSelection');
        break;
      case 2:
        context.go('/onboardingAccountConnection');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.customBlack,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => navigateToPage(0),
            child: Column(
              children: [
                const Text(
                  "Basic\nInformation",
                  style: TextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Container(
                  height: 5,
                  width: 90,
                  color: widget.selectedIndex == 0
                      ? AppColors.customPink
                      : Colors.transparent,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => navigateToPage(1),
            child: Column(
              children: [
                const Text(
                  "Vehicle\nSelection",
                  style: TextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Container(
                  height: 5,
                  width: 90,
                  color: widget.selectedIndex == 1
                      ? AppColors.customPink
                      : Colors.transparent,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => navigateToPage(2),
            child: Column(
              children: [
                const Text(
                  "Account\nConnection",
                  style: TextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Container(
                  height: 5,
                  width: 90,
                  color: widget.selectedIndex == 2
                      ? AppColors.customPink
                      : Colors.transparent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
