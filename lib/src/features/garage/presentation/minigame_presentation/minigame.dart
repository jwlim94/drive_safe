import 'package:drive_safe/src/features/garage/presentation/minigame_presentation/virtual_cars/virtual_car.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RacingGame extends FlameGame with KeyboardEvents {
  late VirtualCar player;
  final double speed = 100; // Speed in pixels per second

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    player = VirtualCar()
      ..position = size / 2
      ..width = 30
      ..height = 30
      ..anchor = Anchor.center;

    add(player);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
        player.position.add(Vector2(0, -speed * deltaTime()));
      }
      if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
        player.position.add(Vector2(0, speed * deltaTime()));
      }
      if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
        player.position.add(Vector2(-speed * deltaTime(), 0));
      }
      if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
        player.position.add(Vector2(speed * deltaTime(), 0));
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  double deltaTime() => 1 / 60; // Assuming 60 FPS for smooth movement
}
