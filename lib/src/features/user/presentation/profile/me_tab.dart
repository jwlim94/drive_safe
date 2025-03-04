import 'package:drive_safe/src/features/car/presentation/providers/current_car_state_provider.dart';
import 'package:drive_safe/src/features/leaderboard/presentation/providers/current_league_state_provider.dart';
import 'package:drive_safe/src/features/user/presentation/profile/gauge_meter.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/utils/color_utils.dart';
import 'package:drive_safe/src/shared/utils/league_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MeTab extends ConsumerWidget {
  const MeTab({super.key});

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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        LeagueUtils.getSvgPath(currentLeague.name),
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        LeagueUtils.getFormattedLeagueName(currentLeague.name),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.customWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/flame.svg',
                            width: 40,
                            height: 40,
                          ),
                          Positioned(
                            top: 18,
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
                      const Text(
                        'Drive Streak',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.customWhite,
                        ),
                      ),
                    ],
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
