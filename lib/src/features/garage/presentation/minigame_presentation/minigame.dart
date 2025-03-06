import 'package:drive_safe/src/features/garage/presentation/minigame_presentation/virtual_cars/player_stats.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RacingGame extends FlameGame with RiverpodGameMixin, KeyboardEvents {
  late RiverPodAwarePlayerStats playerStats;
  final double speed = 200; // Adjust speed as needed
  final Set<LogicalKeyboardKey> keysPressed = {};

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    playerStats = RiverPodAwarePlayerStats()
      ..position = size / 2
      ..width = 30
      ..height = 30
      ..anchor = Anchor.center;

    add(playerStats);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keys) {
    if (event is KeyDownEvent) {
      keysPressed.add(event.logicalKey);
    } else if (event is KeyUpEvent) {
      keysPressed.remove(event.logicalKey);
    }
    return KeyEventResult.handled;
  }

  @override
  void update(double dt) {
    super.update(dt);

    Vector2 movement = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      movement.y -= speed * dt;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      movement.y += speed * dt;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      movement.x -= speed * dt;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      movement.x += speed * dt;
    }

    playerStats.position.add(movement);
  }
}
