import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AchievementTab extends ConsumerWidget {
  const AchievementTab({super.key});

  static const List<int> hotStreakBadges = [10, 20, 50, 100, 250, 365];
  static const List<int> enduranceBadges = [30, 60, 90, 120, 150, 180];

  /// Helper function to create 3x3-like badge rows
  List<Widget> buildBadgeRows(
    List<int> badgeList,
    String type,
    int currentValue,
  ) {
    List<Widget> rows = [];
    for (int i = 0; i < badgeList.length; i += 3) {
      final rowBadges = badgeList.skip(i).take(3).map((value) {
        final path = 'assets/images/badges/$type/$value.png';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4), // tight spacing
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

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Achievements',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            const SizedBox(height: 30),

            /// 🔥 Hot Streak
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
            const SizedBox(height: 4),
            ...buildBadgeRows(
                hotStreakBadges, 'hotstreak', currentUser.driveStreak),

            const SizedBox(height: 20),

            /// 🏁 Endurance
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
            const SizedBox(height: 4),
            ...buildBadgeRows(
                enduranceBadges, 'endurance', currentUser.enduranceMinutes),
          ],
        ),
      ),
    );
  }
}
