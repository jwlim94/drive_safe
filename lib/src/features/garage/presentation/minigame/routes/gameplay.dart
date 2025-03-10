import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';

class Gameplay extends Component with KeyboardHandler {
  Gameplay({super.key, required this.onPausePressed, this.onGameOver});

  final VoidCallback? onPausePressed;
  final VoidCallback? onGameOver;

  static const id = 'GamePlay';

  @override
  Future<void> onLoad() async {
    final map = await TiledComponent.load("desert_track.tmx", Vector2.all(24));
    await add(map);
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
