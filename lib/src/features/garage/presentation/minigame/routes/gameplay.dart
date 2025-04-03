import 'dart:async';
import 'dart:math';

import 'package:drive_safe/src/features/garage/presentation/minigame/input.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/minigame.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/player.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/players/player_stats.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/ui/game_hud.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/world/infinite_road_map.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/world/obstacle.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/world/road_boundary.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class Gameplay extends Component with KeyboardHandler {
  Gameplay({
    super.key,
    required this.onPausePressed,
    this.onGameOver,
    required this.sfxEnabled,
  });

  final VoidCallback onPausePressed;
  final VoidCallback? onGameOver;
  final bool sfxEnabled;

  final input = Input();
  late final PlayerStats playerStats;
  late final Player player;
  late final InfiniteRoadMap roadMap;
  late final World gameWorld;
  late final CameraComponent camera;
  late final GameHUD hud;

  static const id = 'GamePlay';

  final _random = Random();
  double _lastObstaclePosition = 0;
  final _minObstacleSpacing = 300;
  final _obstacleSpawnChance = 0.6;

  @override
  Future<void> onLoad() async {
    playerStats = PlayerStats();
    await add(playerStats);

    roadMap = InfiniteRoadMap();
    await add(roadMap);

    player = Player()
      ..position = Vector2(
        roadMap.roadCenter,
        150,
      );

    final roadBoundary = RoadBoundary(
      roadWidth: roadMap.roadWidth,
      roadCenter: roadMap.roadCenter,
      roadStartX: roadMap.roadStartX,
      player: player,
      playerStats: playerStats,
    );

    gameWorld = World(
      children: [roadMap, player, roadBoundary],
    );
    await add(gameWorld);

    camera = CameraComponent.withFixedResolution(
      width: 200,
      height: 300,
      world: gameWorld,
    );
    await add(camera);

    hud = GameHUD(
      playerStats: playerStats,
      screenSize: Vector2(200, 300),
      safeArea: true,
    );
    await camera.viewport.add(hud);

    await add(input);

    camera.follow(player);

    roadMap.setTarget(player);

    final joystick = TouchController()
      ..position = Vector2(
        175,
        275,
      );
    await camera.viewport.add(joystick);

    input.joystick = joystick;

    await hud.add(joystick);

    _spawnObstacle(player.position.y);

    // Add debug line
    // final debugLine = DebugBoundaryLine(
    //   roadStartX: roadMap.roadStartX,
    //   roadWidth: roadMap.roadWidth,
    //   minX: roadMap.roadStartX + 5,
    //   maxX: roadMap.roadStartX + roadMap.roadWidth - 5,
    // )..size = Vector2(200, 300);
    // await gameWorld.add(debugLine);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (playerStats.isDead) {
      onGameOver?.call();
      return;
    }

    final currentPlayerY = player.position.y;
    if (currentPlayerY - _lastObstaclePosition >= _minObstacleSpacing) {
      if (_random.nextDouble() < _obstacleSpawnChance) {
        _spawnObstacle(currentPlayerY);
        _lastObstaclePosition = currentPlayerY;
      }
    }

    playerStats.addScore(1);
  }

  void _spawnObstacle(double yPosition) {
    final minX = roadMap.roadStartX + 5;
    final maxX = roadMap.roadStartX + roadMap.roadWidth - 5;
    final randomX = minX + _random.nextDouble() * (maxX - minX);

    final carObstacle = RoadObstacle(
      roadWidth: roadMap.roadWidth,
      roadStartX: roadMap.roadStartX,
      position: Vector2(randomX, yPosition + 300),
      player: player,
      playerStats: playerStats,
      obstacleSize: Vector2.all(16),
      speed: 0,
      sfxEnabled: sfxEnabled,
    );

    gameWorld.add(carObstacle);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.keyP)) {
      onPausePressed.call();
    } else if (keysPressed.contains(LogicalKeyboardKey.keyO)) {
      onGameOver?.call();
    }
    return super.onKeyEvent(event, keysPressed);
  }
}

// Debug line
class DebugBoundaryLine extends PositionComponent {
  DebugBoundaryLine({
    required this.roadStartX,
    required this.roadWidth,
    required this.minX,
    required this.maxX,
  });

  final double roadStartX;
  final double roadWidth;
  final double minX;
  final double maxX;

  @override
  void render(Canvas canvas) {
    final roadPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(roadStartX, 0),
      Offset(roadStartX, size.y),
      roadPaint,
    );

    canvas.drawLine(
      Offset(roadStartX + roadWidth, 0),
      Offset(roadStartX + roadWidth, size.y),
      roadPaint,
    );

    final obstaclePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(minX, 0),
      Offset(minX, size.y),
      obstaclePaint,
    );

    canvas.drawLine(
      Offset(maxX, 0),
      Offset(maxX, size.y),
      obstaclePaint,
    );
  }
}
