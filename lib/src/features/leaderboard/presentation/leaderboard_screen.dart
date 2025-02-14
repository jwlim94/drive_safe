import 'package:carousel_slider/carousel_slider.dart';
import 'package:drive_safe/src/features/leaderboard/domain/leagues.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/custom_player_card.dart';
import 'package:drive_safe/src/shared/widgets/custom_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  List<League> _leagues = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _leagues = League.getLeagues();

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
    CarouselSliderController buttonCarouselController =
        CarouselSliderController();

    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicator: CustomTabIndicator(width: indicatorWidth),
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                child: Text(
                  'GLOBAL',
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
          const SizedBox(height: 20),
          // Check selected tab and display the respective content
          if (_selectedIndex == 0) ...<Widget>[
            CarouselSlider(
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                height: 125,
                autoPlay: false,
                enlargeCenterPage: true,
                enlargeFactor: .4,
                enableInfiniteScroll: false,
                viewportFraction: 0.5,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              items: _leagues.map((league) {
                return Builder(
                  builder: (context) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            league.svgPath,
                            height: 50,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            league.name,
                            style: TextStyles.bodyMedium
                                .copyWith(color: league.color),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            // switch (currentIndex){
            //   0 => /*Query to db*/(0),
            //   1 => /*Query to db*/(1),
            //   2 => /*Query to db*/(2),
            //   3 => /*Query to db*/(3),
            //   4 => /*Query to db*/(4),
            //   5 => /*Query to db*/(5),
            //   _ => /*Query to db*/
            // },
            Column(
              children: [
                CustomPlayerCard(
                  position: 1, //Put in player stats
                  playerName: "Jake", //Put in player name
                  onPressed: VoidCallbackAction.new,
                  backgroundColor: AppColors.customWhite,
                  leaguePositionColor:
                      _leagues[currentIndex].color, //Put in player stats
                  borderOutline:
                      _leagues[currentIndex].color, //Put in player stats
                  points: 500, //Put in player stats
                  positionMovement: "Increased", //Put in player stats
                  playerColor: AppColors.customBlack, //Put in player color
                ),
              ],
            ),
          ],
          if (_selectedIndex == 1) ...[
            const Center(
              child: Text(
                'Friends Leaderboard',
                style: TextStyles.h4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
