import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:drive_safe/src/features/user/presentation/profile/achievement_tab.dart';
import 'package:drive_safe/src/features/user/presentation/profile/gauge_meter.dart';
import 'package:drive_safe/src/features/user/presentation/providers/friend_car_provider.dart';
import 'package:drive_safe/src/features/user/presentation/providers/friend_league_provider.dart';
import 'package:drive_safe/src/features/user/presentation/providers/friend_user_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/utils/color_utils.dart';
import 'package:drive_safe/src/shared/utils/league_utils.dart';
import 'package:drive_safe/src/shared/widgets/checkered_flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FriendProfileScreen extends ConsumerWidget {
  final String userId;

  const FriendProfileScreen({super.key, required this.userId});

  Widget _buildProfileBadge({required Widget icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor, width: 2),
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF2C2C2E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(76),
            offset: const Offset(0, 2),
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.customWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighScoreCard(User user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade400, Colors.purple.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.videogame_asset, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Driving Game Score',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              user.highestScore.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendUserAsync = ref.watch(friendUserProvider(userId));
    final friendCarAsync = ref.watch(friendCarProvider(userId));
    final friendLeagueAsync = ref.watch(friendLeagueProvider(userId));

    return Stack(
      children: [
        const CheckeredFlag(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(
              color: AppColors.customWhite,
              size: 45,
            ),
          ),
          body: friendUserAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(
              child: Text(
                'Friend is warming up',
                style: TextStyle(
                  color: Colors.white, // 글씨 색을 흰색으로 설정
                  fontSize: 20, // 글씨 크기 키우기
                  fontWeight: FontWeight.bold, // 글씨 굵기 설정 (선택 사항)
                ),
              ),
            ),
            data: (user) {
              if (user == null) {
                return const Center(child: Text('Friend not found'));
              }
              final car = friendCarAsync.asData?.value;
              final league = friendLeagueAsync.asData?.value;

              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30), // 양옆에 패딩 추가
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: ColorUtils.toColor(user.primaryColor),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                user.name.isNotEmpty
                                    ? user.name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  color:
                                      ColorUtils.toColor(user.secondaryColor),
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.customWhite,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  car != null
                                      ? '${car.description} ${car.type}'
                                      : 'No car info',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: AppColors.customWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildHighScoreCard(user),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: _buildProfileBadge(
                              icon: SvgPicture.asset(
                                LeagueUtils.getSvgPath(
                                    league?.name ?? 'bronze'),
                                width: 36,
                                height: 36,
                              ),
                              label: LeagueUtils.getFormattedLeagueName(
                                  league?.name ?? 'bronze'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildProfileBadge(
                              icon: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/flame.svg',
                                    width: 36,
                                    height: 36,
                                  ),
                                  Positioned(
                                    top: 14,
                                    child: Text(
                                      user.driveStreak.toString(),
                                      style: const TextStyle(
                                        color: AppColors.streakNumber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              label: 'Streak',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AchievementTab(),
                                  ),
                                );
                              },
                              child: _buildProfileBadge(
                                icon: const Icon(Icons.star,
                                    color: Colors.amber, size: 36),
                                label: 'Achievements',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Level ${(user.drivePoints / 10000).floor()}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 100),
                      GaugeMeter(points: user.drivePoints),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
