import 'package:carousel_slider/carousel_slider.dart';
import 'package:drive_safe/src/features/leaderboard/domain/leagues.dart';
import 'package:drive_safe/src/features/leaderboard/presentation/controllers/fetch_user_league_controller.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/custom_player_card.dart';
import 'package:drive_safe/src/shared/widgets/custom_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  List<League> _carouselLeagues = [];
  int currentIndex = 0;
  CarouselSliderController? buttonCarouselController;

  @override
  void initState() {
    super.initState();
    buttonCarouselController = CarouselSliderController();
    _tabController = TabController(length: 2, vsync: this);
    _carouselLeagues = League.getLeagues();

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
    final leagueAsync =
        ref.watch(fetchUserLeagueControllerProvider(currentIndex));
    final currentUser = ref.watch(currentUserStateProvider);

    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicator: CustomTabIndicator(width: indicatorWidth),
            dividerColor: Colors.transparent,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
              ref.invalidate(fetchUserLeagueControllerProvider);
            },
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
                ref.invalidate(fetchUserLeagueControllerProvider);
              },
            ),
            items: _carouselLeagues.map((league) {
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
                          league.displayName,
                          style: TextStyles.bodyMedium
                              .copyWith(color: Color(league.color)),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
          if (_selectedIndex == 0) ...<Widget>[
            leagueAsync.when(
              data: (leagueData) => Column(
                children: leagueData.map((data) {
                  final league = data['league'] as League;
                  final user = data['user'];

                  return CustomPlayerCard(
                    position: league.position,
                    playerName: user?['name'],
                    userSecondaryColor: user?['secondaryColor'],
                    userPrimaryColor: user?['primaryColor'],
                    onPressed: () {}, // Provide a valid callback
                    backgroundColor: (user?['id'] == currentUser?.id)
                        ? Color.lerp(
                            (currentUser!.primaryColor == 4294967295)
                                ? Color(currentUser.secondaryColor)
                                : Color(currentUser.primaryColor),
                            AppColors.customWhite,
                            .5,
                          )!
                        : AppColors.customWhite,
                    tierColor: Color(league.color),
                    borderOutline: Color(league.color),
                    points: league.points,
                    positionMovement: league.movement,
                    playerColor: Color(user?['primaryColor'] ?? 4293980400),
                  );
                }).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  "Error: $error",
                  style: TextStyles.error,
                ),
              ),
            ),
          ],
          if (_selectedIndex == 1) ...<Widget>[
            leagueAsync.when(
              data: (leagueData) {
                // Filter out users who are not friends
                final friendsOnly = leagueData.where((data) {
                  final user = data['user'];
                  return user != null &&
                          currentUser?.friends.contains(user['id']) == true ||
                      currentUser?.id.contains(user['id']) == true;
                }).toList();

                return friendsOnly.isEmpty
                    ? const Center(
                        child: Text(
                          "No Friends Here!",
                          style: TextStyles.h4,
                        ),
                      )
                    : Column(
                        children: friendsOnly.map((data) {
                          final league = data['league'] as League;
                          final user = data['user'];

                          return CustomPlayerCard(
                            position: league.position,
                            playerName: user['name'],
                            userSecondaryColor: user['secondaryColor'],
                            userPrimaryColor: user['primaryColor'],
                            onPressed: () {}, // Provide a valid callback
                            backgroundColor: (user['id'] == currentUser?.id)
                                ? Color.lerp(
                                    (currentUser!.primaryColor == 4294967295)
                                        ? Color(currentUser.secondaryColor)
                                        : Color(currentUser.primaryColor),
                                    AppColors.customWhite,
                                    .5,
                                  )!
                                : AppColors.customWhite,
                            tierColor: Color(league.color),
                            borderOutline: Color(league.color),
                            points: league.points,
                            positionMovement: league.movement,
                            playerColor:
                                Color(user['primaryColor'] ?? 4293980400),
                          );
                        }).toList(),
                      );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  "Error: $error",
                  style: TextStyles.error,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
