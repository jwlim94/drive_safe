import 'package:drive_safe/src/features/garage/presentation/minigame_presentation/minigame.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RacingGameScreen extends ConsumerStatefulWidget {
  final RacingGame game;
  const RacingGameScreen({super.key, required this.game});

  @override
  ConsumerState<RacingGameScreen> createState() => _RacingScreenState();
}

class _RacingScreenState extends ConsumerState<RacingGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rival Racing'),
      ),
      body: GameWidget(
        game: widget.game,
      ), // Embed the game
    );
  }
}
