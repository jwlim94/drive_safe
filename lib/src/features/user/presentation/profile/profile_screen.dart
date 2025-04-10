import 'package:drive_safe/src/features/user/presentation/profile/friends_tab.dart';
import 'package:drive_safe/src/features/user/presentation/profile/me_tab.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/enums.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/checkered_flag.dart';
import 'package:drive_safe/src/shared/widgets/custom_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double indicatorWidth = (screenWidth * 0.5) - (screenWidth * 0.15);
    final double horizontalPadding = screenWidth * 0.075;

    return Stack(
      children: [
        const CheckeredFlag(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  padding: const EdgeInsets.only(right: 12),
                  icon: const Icon(
                    Icons.settings,
                    color: AppColors.customWhite,
                    size: 30,
                  ),
                  onPressed: () => context.goNamed(AppRoute.settings.name),
                ),
                TabBar(
                  controller: _tabController,
                  indicator: CustomTabIndicator(width: indicatorWidth),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      child: Text(
                        'ME',
                        style: TextStyles.h3.copyWith(
                          color: _selectedIndex == 0
                              ? AppColors.customBlue
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'FRIENDS',
                        style: TextStyles.h3.copyWith(
                          color: _selectedIndex == 1
                              ? AppColors.customBlue
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 15,
                    ),
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        MeTab(),
                        FriendsTab(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
