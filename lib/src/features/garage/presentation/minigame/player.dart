import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:drive_safe/src/features/garage/presentation/minigame/routes/gameplay.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Player extends PositionComponent
    with CollisionCallbacks, HasGameReference, HasAncestor<Gameplay> {
  Player();

  late final SpriteComponent _body;
  final _moveDirection = Vector2(0, 1); // downward for now

  static const _maxSpeed = 160;
  static const _acceleration = 0.5;
  var _speed = 0.0;

  // 깜빡임 효과 관련 변수
  bool _isVisible = true;
  static const _blinkInterval = 0.1;
  double _blinkTimer = 0;

  @override
  FutureOr<void> onLoad() async {
    final tiles = await game.images.load('player_car_blue_16_x_16.png');
    final spriteSheet = SpriteSheet(image: tiles, srcSize: Vector2.all(16));

    await add(RectangleHitbox(
      size: Vector2(10, 10),
      anchor: Anchor.center,
    ));

    _body = SpriteComponent(
      sprite: spriteSheet.getSprite(0, 4), // index
      anchor: Anchor.center,
    );
    await add(_body);
  }

  @override
  void update(double dt) {
    _moveDirection.x = ancestor.input.hAxis;
    _moveDirection.y = 1;

    _moveDirection.normalize();

    _speed = lerpDouble(
        _speed, ancestor.playerStats.speed * 100, _acceleration * dt)!;

    angle = _moveDirection.screenAngle() + pi;
    position.addScaled(_moveDirection, _speed * dt);

    // 무적 시간 동안 깜빡임 효과
    final playerStats = ancestor.playerStats;
    if (playerStats.isInvincible) {
      _blinkTimer += dt;
      if (_blinkTimer >= _blinkInterval) {
        _blinkTimer = 0;
        _isVisible = !_isVisible;
      }
      _body.opacity = _isVisible ? 1.0 : 0.3;
    } else {
      _body.opacity = 1.0;
      _isVisible = true;
      _blinkTimer = 0;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // RoadObstacle이 직접 충돌 처리하기 때문에 여기선 안 해도 됨.
  }
}
