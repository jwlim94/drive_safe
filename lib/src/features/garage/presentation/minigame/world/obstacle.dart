import 'dart:math';
import 'package:drive_safe/src/features/garage/presentation/minigame/player.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/players/player_stats.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class RoadObstacle extends PositionComponent
    with CollisionCallbacks, HasGameRef {
  RoadObstacle({
    required this.roadWidth,
    required this.roadStartX,
    required Vector2 position,
    required this.player,
    required this.playerStats,
    this.speed = 100,
    Vector2? obstacleSize,
  }) : super(position: position);

  final double roadWidth;
  final double roadStartX;
  final Player player;
  final PlayerStats playerStats;
  final double speed;

  bool _hasCollided = false;

  SpriteComponent? _carSprite;
  int _carColorIndex = 0;

  @override
  Future<void> onLoad() async {
    size = Vector2(16, 16); // 🔒 스프라이트와 컴포넌트 크기 모두 16 고정

    // 정확하고 타이트한 히트박스 설정 (조금 작게, 중심 기준)
    await add(RectangleHitbox(
      size: Vector2(10, 10),
      anchor: Anchor.center,
    ));

    // NPC 자동차 스프라이트 로딩
    try {
      final carImage = await gameRef.images.load('npc_cars_16_x_16.png');
      final spriteSheet = SpriteSheet(
        image: carImage,
        srcSize: Vector2.all(16),
      );

      final validRows = [0, 2];
      final randomRow = validRows[Random().nextInt(validRows.length)];

      _carSprite = SpriteComponent(
        sprite: spriteSheet.getSprite(randomRow, 0),
        size: Vector2(16, 16), // 🔒 고정
        anchor: Anchor.center,
      );

      await add(_carSprite!);
    } catch (e) {
      // fallback 생략
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= speed * dt;

    if (position.y < -100) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (!_hasCollided &&
        other is Player &&
        playerStats.invincibilityTime <= 0) {
      _onCollision();
    }
  }

  void _onCollision() {
    if (_hasCollided) return;
    _hasCollided = true;
    playerStats.collision();

    if (_carSprite != null) {
      _carSprite!.opacity = 0.5;
      angle += 0.3;

      Future.delayed(const Duration(milliseconds: 100), () {
        if (isMounted && _carSprite != null) {
          _carSprite!.opacity = 1.0;

          Future.delayed(const Duration(milliseconds: 100), () {
            if (isMounted) {
              angle -= 0.6;

              Future.delayed(const Duration(milliseconds: 800), () {
                if (isMounted) {
                  removeFromParent();
                }
              });
            }
          });
        }
      });
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_carSprite == null) {
      final rect = Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2),
        width: size.x * 0.8,
        height: size.y * 0.9,
      );

      final carColors = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.amber,
      ];

      final carPaint = Paint()
        ..color = carColors[_carColorIndex]
        ..style = PaintingStyle.fill;

      canvas.drawRect(rect, carPaint);

      final borderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawRect(rect, borderPaint);

      final windowPaint = Paint()
        ..color = Colors.lightBlue.shade100
        ..style = PaintingStyle.fill;

      final windowRect = Rect.fromLTWH(
        size.x * 0.2,
        size.y * 0.2,
        size.x * 0.6,
        size.y * 0.3,
      );

      canvas.drawRect(windowRect, windowPaint);
    }
  }
}
