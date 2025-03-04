import 'package:drive_safe/src/features/garage/application/racing_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class RacingGameScreen extends StatelessWidget {
  final RacingGame game;
  const RacingGameScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Racing Minigame'),
      ),
      body: GameWidget(
        game: game,
      ), // Embed the game
    );
  }
}
