import 'package:drive_safe/src/features/garage/presentation/minigame/player.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/players/player_stats.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// 도로 경계를 감지하고 플레이어가 벗어날 경우 충돌 처리를 하는 컴포넌트
class RoadBoundary extends Component with HasGameRef {
  RoadBoundary({
    required this.roadWidth,
    required this.roadCenter,
    required this.roadStartX,
    required this.player,
    required this.playerStats,
  });

  // 도로 너비
  final double roadWidth;

  // 도로 중앙 X 위치
  final double roadCenter;

  // 도로 시작 X 위치
  final double roadStartX;

  // 플레이어 참조
  final Player player;

  // 플레이어 상태 참조
  final PlayerStats playerStats;

  // 도로 경계 너비 (실제 충돌 판정 영역)
  final double boundaryWidth = 4.0;

  // 플레이어 차량 너비의 절반 (충돌 계산용)
  final double playerWidthHalf = 8.0;

  @override
  Future<void> onLoad() async {
    // 빨간 경계선 제거
  }

  @override
  void update(double dt) {
    final playerX = player.position.x;

    // 도로의 좌측 경계
    final leftBoundary = roadStartX + boundaryWidth;

    // 도로의 우측 경계 (오른쪽으로 더 확장)
    final rightBoundary = roadStartX + roadWidth - boundaryWidth;

    // 플레이어가 도로 경계를 벗어났는지 체크 (플레이어 크기 고려)
    final isOutOfBounds = playerX < leftBoundary || playerX > rightBoundary;

    // 경계를 벗어났을 때 충돌 처리
    if (isOutOfBounds && playerStats.invincibilityTime <= 0) {
      // 목숨 감소 및 무적 상태 설정
      playerStats.collision();

      // 도로 중앙으로 플레이어 위치 재설정
      if (playerStats.lives > 0) {
        _resetPlayerPosition();
      }
    }
  }

  // 플레이어 위치 재설정
  void _resetPlayerPosition() {
    // 현재 Y 위치는 유지하고 X 위치는 도로 중앙으로
    player.position.x = roadCenter;
  }
}
