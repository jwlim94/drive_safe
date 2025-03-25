import 'dart:async';
import 'dart:math';

import 'package:drive_safe/src/features/garage/presentation/minigame/input.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/player.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/players/player_stats.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/ui/game_hud.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/world/infinite_road_map.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/world/obstacle.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/world/road_boundary.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Gameplay extends Component with KeyboardHandler {
  Gameplay({super.key, required this.onPausePressed, this.onGameOver});

  final VoidCallback? onPausePressed;
  final VoidCallback? onGameOver;

  final input = Input();
  late final PlayerStats playerStats;
  late final Player player;
  late final InfiniteRoadMap roadMap;
  late final World gameWorld;
  late final CameraComponent camera;
  late final GameHUD hud;

  static const id = 'GamePlay';

  // 장애물 생성 관련 변수
  final _random = Random();
  double _lastObstaclePosition = 0;
  final _minObstacleSpacing = 300; // 최소 장애물 간격 증가
  final _obstacleSpawnChance = 0.6; // 생성 확률 증가

  @override
  Future<void> onLoad() async {
    // 플레이어 통계 초기화
    playerStats = PlayerStats();
    await add(playerStats);

    // 무한 도로 맵 생성
    roadMap = InfiniteRoadMap();
    await add(roadMap);

    player = Player()
      ..position = Vector2(
        roadMap.roadCenter, // 도로 중앙 X
        50, // 도로 시작 Y보다 살짝 아래
      );

    // 도로 경계 생성
    final roadBoundary = RoadBoundary(
      roadWidth: roadMap.roadWidth,
      roadCenter: roadMap.roadCenter,
      roadStartX: roadMap.roadStartX,
      player: player,
      playerStats: playerStats,
    );

    // 게임 월드 설정
    gameWorld = World(
      children: [roadMap, player, roadBoundary],
    );
    await add(gameWorld);

    // 카메라 설정
    camera = CameraComponent.withFixedResolution(
      width: 200,
      height: 300,
      world: gameWorld,
    );
    await add(camera);

    // HUD 추가
    hud = GameHUD(
      playerStats: playerStats,
      screenSize: Vector2(200, 300),
      safeArea: true,
    );
    await camera.viewport.add(hud);

    // 입력 처리기 추가
    await add(input);

    // 카메라가 플레이어를 따라가도록 설정
    camera.follow(player);

    // 도로 맵이 플레이어를 추적하도록 설정
    roadMap.setTarget(player);

    // 초기 장애물 생성
    _spawnObstacle(player.position.y);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 플레이어가 죽었는지 확인
    if (playerStats.isDead) {
      onGameOver?.call();
      return;
    }

    // 장애물 생성 로직
    final currentPlayerY = player.position.y;
    if (currentPlayerY - _lastObstaclePosition >= _minObstacleSpacing) {
      if (_random.nextDouble() < _obstacleSpawnChance) {
        _spawnObstacle(currentPlayerY);
        _lastObstaclePosition = currentPlayerY;
      }
    }

    // 점수 증가 (거리 기반)
    playerStats.addScore(1);
  }

  void _spawnObstacle(double yPosition) {
    // 도로 내에서 랜덤한 X 위치 선택
    final minX = roadMap.roadStartX + 20;
    final maxX = roadMap.roadStartX + roadMap.roadWidth - 20;
    final randomX = minX + _random.nextDouble() * (maxX - minX);

    final carObstacle = RoadObstacle(
      roadWidth: roadMap.roadWidth,
      roadStartX: roadMap.roadStartX,
      position: Vector2(randomX, yPosition + 300),
      player: player,
      playerStats: playerStats,
      obstacleSize: Vector2.all(16), // 🔧 고정 크기
      speed: 0,
    );

    gameWorld.add(carObstacle);
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
