import 'package:drive_safe/src/features/garage/presentation/minigame/minigame.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_highest_score_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_required_focus_time_in_seconds_controller.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RacingGameScreen extends ConsumerWidget {
  const RacingGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserStateProvider);
    ref.watch(updateUserHighestScoreControllerProvider);
    ref.watch(updateUserRequiredFocusTimeInSecondsControllerProvider);

    if (currentUser == null) return Container();

    void onGameOver(int score) {
      final currentSavedScore = currentUser.highestScore;

      if (currentSavedScore > score) return;

      ref
          .read(updateUserHighestScoreControllerProvider.notifier)
          .updateHighestScore(currentUser.id, score);
    }

    void onGameStart() {
      ref
          .read(updateUserRequiredFocusTimeInSecondsControllerProvider.notifier)
          .updateUserRequiredFocusTimeInSeconds(currentUser.id, 600);
    }

    return Scaffold(
      body: GameWidget.controlled(
        gameFactory: () => RacingGame(
          onScoreUpdate: onGameOver,
          onResetRequiredFocusTime: onGameStart,
        ),
      ),
    );
  }
}
