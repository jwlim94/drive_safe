import 'package:drive_safe/src/features/garage/presentation/minigame_presentation/minigame.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame_presentation/virtual_cars/player_stats.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';

final gameInstance = RacingGame();
final GlobalKey<RiverpodAwareGameWidgetState> gameWidgetKey =
    GlobalKey<RiverpodAwareGameWidgetState>();

class RacingGameScreen extends StatelessWidget {
  const RacingGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(child: FlutterPlayerStatsComponent()),
          Expanded(
            child: RiverpodAwareGameWidget(
              key: gameWidgetKey,
              game: gameInstance,
            ),
          ),
        ],
      ),
    );
  }
}
