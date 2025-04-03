import 'package:drive_safe/src/features/garage/presentation/minigame/player.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/players/player_stats.dart';
import 'package:flame/components.dart';

class RoadBoundary extends Component with HasGameRef {
  RoadBoundary({
    required this.roadWidth,
    required this.roadCenter,
    required this.roadStartX,
    required this.player,
    required this.playerStats,
  });

  final double roadWidth;

  final double roadCenter;

  final double roadStartX;

  final Player player;

  final PlayerStats playerStats;

  final double boundaryWidth = 4.0;

  final double playerWidthHalf = 8.0;

  @override
  Future<void> onLoad() async {}

  @override
  void update(double dt) {
    final playerX = player.position.x;

    final leftBoundary = roadStartX + boundaryWidth;

    final rightBoundary = roadStartX + roadWidth - boundaryWidth;

    final isOutOfBounds = playerX < leftBoundary || playerX > rightBoundary;

    if (isOutOfBounds && playerStats.invincibilityTime <= 0) {
      playerStats.collision();

      if (playerStats.lives > 0) {
        _resetPlayerPosition();
      }
    }
  }

  void _resetPlayerPosition() {
    player.position.x = roadCenter;
  }
}
