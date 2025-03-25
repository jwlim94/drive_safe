import 'package:drive_safe/src/features/car/presentation/providers/current_car_state_provider.dart';
import 'package:drive_safe/src/features/leaderboard/presentation/providers/current_league_state_provider.dart';
import 'package:drive_safe/src/features/user/presentation/profile/achievement_tab.dart';
import 'package:drive_safe/src/features/user/presentation/profile/gauge_meter.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/utils/color_utils.dart';
import 'package:drive_safe/src/shared/utils/league_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MeTab extends ConsumerWidget {
  const MeTab({super.key});

  // Build a reusable profile badge with icon and label
  Widget _buildProfileBadge({required Widget icon, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor, width: 2),
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF2C2C2E),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
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
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.customWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserStateProvider);
    final currentCar = ref.watch(currentCarStateProvider);
    final currentLeague = ref.watch(currentLeagueStateProvider);

    // TODO: Handle error state
    if (currentUser == null) return Container();
    if (currentCar == null) return Container();
    if (currentLeague == null) return Container();

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: ColorUtils.toColor(currentUser.primaryColor),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    currentUser.name[0].toUpperCase(),
                    style: TextStyle(
                      color: ColorUtils.toColor(currentUser.secondaryColor),
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
                      currentUser.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.customWhite,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${currentCar.description} ${currentCar.type}",
                      style: const TextStyle(
                        fontSize: 24,
                        color: AppColors.customWhite,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              _buildProfileBadge(
                icon: SvgPicture.asset(
                  LeagueUtils.getSvgPath(currentLeague.name),
                  width: 36,
                  height: 36,
                ),
                label: LeagueUtils.getFormattedLeagueName(currentLeague.name),
              ),
              const SizedBox(width: 12),
              _buildProfileBadge(
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
                        currentUser.driveStreak.toString(),
                        style: const TextStyle(
                          color: AppColors.streakNumber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                label: 'Focus Streak',
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Navigate to AchievementTab when tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AchievementTab(),
                      ),
                    );
                  },
                  child: _buildProfileBadge(
                    icon: const Icon(Icons.star, color: Colors.amber, size: 36),
                    label: 'Achievement',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Level ${(currentUser.drivePoints / 10000).floor()}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 100),
          GaugeMeter(points: currentUser.drivePoints),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}
