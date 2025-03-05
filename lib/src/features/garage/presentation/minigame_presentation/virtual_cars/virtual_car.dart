import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class VirtualCar extends PositionComponent {
  static final _paint = Paint()..color = Colors.white;
  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }

  void move(Vector2 delta) {
    position.add(delta);
  }
}
