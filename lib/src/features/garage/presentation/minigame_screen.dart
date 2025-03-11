import 'package:drive_safe/src/features/garage/presentation/minigame/minigame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class RacingGameScreen extends StatelessWidget {
  const RacingGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GameWidget.controlled(gameFactory: RacingGame.new),
    );
  }
}
