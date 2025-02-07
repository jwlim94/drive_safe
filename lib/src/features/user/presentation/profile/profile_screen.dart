import 'package:drive_safe/src/features/user/presentation/profile/friends_tab.dart';
import 'package:drive_safe/src/features/user/presentation/profile/me_tab.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/custom_tab_indicator.dart';
import 'package:flutter/material.dart';

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

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: AppColors.customBlack,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 12),
            icon: const Icon(
              Icons.settings,
              color: AppColors.customGray,
              size: 32,
            ),
            onPressed: () {
              print('Go to settings page');
            },
          )
        ],
      ),
      body: Column(
        children: [
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
              vertical: 48,
            ),
            child: TabBarView(
              controller: _tabController,
              children: const [
                MeTab(),
                FriendsTab(),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
