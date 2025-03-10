import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:drive_safe/src/features/garage/presentation/minigame/routes/gameplay.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Player extends PositionComponent
    with HasGameReference, HasAncestor<Gameplay> {
  Player({super.position});

  late final SpriteComponent _body;
  final _moveDirection = Vector2(0, 1); // downward for now

  static const _maxSpeed = 160;
  static const _acceleration = 0.5;
  var _speed = 0.0;

  @override
  FutureOr<void> onLoad() async {
    final tiles = await game.images.load('player_car_blue_16_x_16.png');
    final spriteSheet = SpriteSheet(image: tiles, srcSize: Vector2.all(16));

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

    _speed = lerpDouble(_speed, _maxSpeed, _acceleration * dt)!;

    angle = _moveDirection.screenAngle() + pi;
    position.addScaled(_moveDirection, _speed * dt);
  }
}
