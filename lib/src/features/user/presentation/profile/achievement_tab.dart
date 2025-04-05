import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/checkered_flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AchievementTab extends ConsumerWidget {
  final List<String>? friendBadges;
  final String? friendId;

  const AchievementTab({super.key, this.friendBadges, this.friendId});

  static const List<int> hotStreakBadges = [10, 20, 50, 100, 250, 365];
  static const List<int> enduranceBadges = [30, 60, 90, 120, 150, 180];

  List<Widget> buildBadgeRows(
    List<int> badgeList,
    String type,
    List<String> unlockedBadges,
  ) {
    List<Widget> rows = [];
    for (int i = 0; i < badgeList.length; i += 3) {
      final rowBadges = badgeList.skip(i).take(3).map((value) {
        final badgeKey = '${type}_$value';
        final isUnlocked = unlockedBadges.contains(badgeKey);
        final path =
            'assets/images/badges/$type/${value}_${isUnlocked ? 'unlocked' : 'locked'}.png';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Image.asset(
            path,
            width: 76,
            height: 76,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        );
      }).toList();

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowBadges,
          ),
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserStateProvider);

    if (currentUser == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1C1C1E),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Use the passed friendBadges or the current user's badges.
    var unlockedBadges = friendBadges ?? currentUser.badges;

    // Check if unlockedBadges are the same as friendBadges
    bool shouldShowRefreshButton = friendId == null;

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
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                const Text('Achievements', style: TextStyles.h2),
                const SizedBox(
                  height: 15,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Hot Streak',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(255, 156, 156, 1),
                    ),
                  ),
                ),
                const Text(
                  'Hot Streaks are for tracking how many days in a row you have achieved your goal',
                  style: TextStyles.finePrint,
                ),
                const SizedBox(height: 4),
                ...buildBadgeRows(hotStreakBadges, 'hotstreak', unlockedBadges),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Endurance',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 147, 255, 170),
                    ),
                  ),
                ),
                const Text(
                  'Endurance badges are for tracking how long you have focused for in a day',
                  style: TextStyles.finePrint,
                ),
                const SizedBox(height: 4),
                ...buildBadgeRows(enduranceBadges, 'endurance', unlockedBadges),
                const SizedBox(height: 15),
                if (shouldShowRefreshButton) ...{
                  IconButton(
                    icon: const Icon(Icons.refresh,
                        color: Colors.white, size: 40),
                    onPressed: () async {
                      await ref
                          .read(currentUserStateProvider.notifier)
                          .refreshAndSetUser();
                    },
                  ),
                  const Text("Refresh Achievements",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                }
              ],
            ),
          ),
        ),
      ],
    );
  }
}
