import 'dart:async';

import 'package:drive_safe/src/features/garage/presentation/minigame/input.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';

class Gameplay extends Component with KeyboardHandler {
  Gameplay({super.key, required this.onPausePressed, this.onGameOver});

  final VoidCallback? onPausePressed;
  final VoidCallback? onGameOver;

  final input = Input();

  static const id = 'GamePlay';

  @override
  Future<void> onLoad() async {
    final map = await TiledComponent.load("road.tmx", Vector2.all(16))
      ..debugMode = true;
    await add(map);

    final player = Player(position: Vector2((map.size.x * 0.5), 0));

    final world = World(children: [map, input, player]);
    await add(world);

    final camera = CameraComponent.withFixedResolution(
      width: 200,
      height: 300,
      world: world,
    );
    await add(camera);

    camera.follow(player);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.keyP)) {
      onPausePressed?.call();
    } else if (keysPressed.contains(LogicalKeyboardKey.keyO)) {
      onGameOver?.call();
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
