import 'dart:ui';

import 'package:drive_safe/src/features/garage/presentation/minigame/minigame.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Input extends Component with KeyboardHandler, HasGameRef {
  bool _leftPressed = false;
  bool _rightPressed = false;
  TouchController? joystick;

  var _leftInput = 0.0;
  var _rightInput = 0.0;
  final sensitivity = 2.0;

  var hAxis = 0.0;
  final maxHAxis = 1.5;
  bool active = false;

  @override
  void update(double dt) {
    _leftInput = lerpDouble(
      _leftInput,
      _leftPressed ? 1.5 : 0,
      sensitivity * dt,
    )!;
    _rightInput = lerpDouble(
      _rightInput,
      _rightPressed ? 1.5 : 0,
      sensitivity * dt,
    )!;

    if (joystick?.direction != JoystickDirection.idle) {
      hAxis = joystick!.relativeDelta.x * maxHAxis;
    } else {
      hAxis = _rightInput - _leftInput;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _leftPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    _rightPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    return super.onKeyEvent(event, keysPressed);
  }
}
