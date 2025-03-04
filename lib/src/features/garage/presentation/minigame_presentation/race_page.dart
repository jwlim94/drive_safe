import 'package:drive_safe/src/features/garage/application/racing_game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class RacePage extends Component with HasGameRef<RacingGame> {
  late final String mapName;

  @override
  Future<void> onLoad() async {
    // Retrieve the selected map (if available)
    //mapName = gameRef.router.currentExtra as String? ?? 'Default Map';

    add(
      TextComponent(
        text: 'Racing on $mapName',
        position: Vector2(100, 50),
        textRenderer: TextPaint(
            style: const TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );

    // Add a back button
    add(
      ButtonComponent(
        position: Vector2(100, 400),
        size: Vector2(200, 50),
        onPressed: () => gameRef.router.pushNamed('home-page'),
      ),
    );
  }
}
