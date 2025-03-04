import 'package:drive_safe/src/features/garage/application/racing_game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class MapSelector extends Component with HasGameRef<RacingGame> {
  @override
  Future<void> onLoad() async {
    add(
      TextComponent(
        text: 'Select a Map',
        position: Vector2(100, 50),
        textRenderer: TextPaint(
            style: const TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }
}
