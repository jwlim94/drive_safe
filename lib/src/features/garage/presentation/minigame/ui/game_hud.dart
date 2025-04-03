import 'package:drive_safe/src/features/garage/presentation/minigame/players/player_stats.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class GameHUD extends PositionComponent {
  GameHUD({
    required this.playerStats,
    required this.screenSize,
    this.safeArea = false,
  }) : super(priority: 1);

  final PlayerStats playerStats;
  final Vector2 screenSize;
  final bool safeArea;

  late final TextComponent _scoreText;
  late final TextComponent _speedText;
  late final List<LifeIcon> _lifeIcons;

  double _scoreTextScale = 1.0;
  double _scoreAnimTimer = 0.0;
  bool _scoreAnimActive = false;

  static const double safeAreaTopPadding = 30;
  static const double safeAreaSidePadding = 10;

  @override
  Future<void> onLoad() async {
    _scoreText = TextComponent(
      text: 'Score: 0',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 2,
              color: Colors.black,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
      position: Vector2(safeArea ? safeAreaSidePadding : 5,
          safeArea ? safeAreaTopPadding : 5),
    );
    await add(_scoreText);

    _speedText = TextComponent(
      text: 'Speed: x1.0',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.cyan,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 2,
              color: Colors.black,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
      position: Vector2(safeArea ? safeAreaSidePadding : 5,
          safeArea ? safeAreaTopPadding + 15 : 20),
    );
    await add(_speedText);

    final double heartY = (safeArea ? safeAreaTopPadding : 5) + 30;

    _lifeIcons = List.generate(
      playerStats.maxLives,
      (index) => LifeIcon(
        position: Vector2(
            (safeArea ? safeAreaSidePadding : 5) + (index * 12), heartY),
        size: Vector2.all(12),
      ),
    );

    for (final icon in _lifeIcons) {
      await add(icon);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    String formattedScore = playerStats.score.toString();

    if (playerStats.score >= 1000) {
      final scoreString = playerStats.score.toString();
      final chars = scoreString.split('');
      final result = <String>[];

      for (int i = 0; i < chars.length; i++) {
        if (i > 0 && (chars.length - i) % 3 == 0) {
          result.add(',');
        }
        result.add(chars[i]);
      }

      formattedScore = result.join();
    }

    _scoreText.text = 'Score: $formattedScore';

    final speedFactor = playerStats.getSpeedFactor();
    _speedText.text = 'Speed: x${speedFactor.toStringAsFixed(1)}';

    if (speedFactor >= 1.7) {
      _speedText.textRenderer = TextPaint(
        style: const TextStyle(
          color: Colors.red,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 2,
              color: Colors.black,
              offset: Offset(1, 1),
            ),
          ],
        ),
      );
    } else if (speedFactor >= 1.4) {
      _speedText.textRenderer = TextPaint(
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 2,
              color: Colors.black,
              offset: Offset(1, 1),
            ),
          ],
        ),
      );
    } else {
      _speedText.textRenderer = TextPaint(
        style: const TextStyle(
          color: Colors.cyan,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 2,
              color: Colors.black,
              offset: Offset(1, 1),
            ),
          ],
        ),
      );
    }

    if (_scoreAnimActive) {
      _scoreAnimTimer += dt;
      if (_scoreAnimTimer >= 0.5) {
        _scoreAnimActive = false;
        _scoreTextScale = 1.0;
      } else {
        _scoreTextScale = 1.3 - (_scoreAnimTimer / 0.5) * 0.3;
      }
      _scoreText.scale = Vector2.all(_scoreTextScale);
    }

    for (int i = 0; i < _lifeIcons.length; i++) {
      final displayIndex = _lifeIcons.length - 1 - i;
      _lifeIcons[displayIndex].visible = i < playerStats.lives;
    }
  }
}

class LifeIcon extends PositionComponent {
  LifeIcon({
    required Vector2 position,
    Vector2? size,
  }) : super(
          position: position,
          size: size ?? Vector2.all(10),
        );

  HeartComponent? _heart;
  bool _visible = true;

  set visible(bool value) {
    if (_visible != value) {
      _visible = value;
      if (_heart != null) {
        if (_visible) {
          _heart!.paint.color = const Color(0xFFFF0000);
        } else {
          _heart!.paint.color = const Color(0x33FF0000);
        }
      }
    }
  }

  @override
  bool get isVisible => true;

  @override
  Future<void> onLoad() async {
    _heart = HeartComponent(
      size: Vector2.all(10),
      paint: Paint()..color = Colors.red,
    );

    await add(_heart!);

    visible = _visible;
  }
}

class HeartComponent extends PositionComponent {
  HeartComponent({
    required Vector2 size,
    required this.paint,
  }) : super(size: size);

  final Paint paint;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final Path path = Path();

    final double width = size.x;
    final double height = size.y;

    final double x = width / 2;
    final double y = height / 2;

    path.moveTo(x, y + height / 3);

    path.cubicTo(
        x - width / 2, y, x - width / 2, y - height / 2, x, y - height / 4);

    path.cubicTo(
        x + width / 2, y - height / 2, x + width / 2, y, x, y + height / 3);

    path.close();

    canvas.drawPath(path, paint);
  }
}
