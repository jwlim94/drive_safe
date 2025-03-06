import 'package:drive_safe/src/features/garage/presentation/minigame_presentation/minigame.dart';
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
      appBar: AppBar(
        title: const Text('Rival Racing'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
