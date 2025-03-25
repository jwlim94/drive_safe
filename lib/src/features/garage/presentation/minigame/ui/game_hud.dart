import 'package:drive_safe/src/features/garage/presentation/minigame/players/player_stats.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 게임 HUD(Head-Up Display) - 생명, 점수 등 표시
class GameHUD extends PositionComponent {
  GameHUD({
    required this.playerStats,
    required this.screenSize,
    this.safeArea = false,
  }) : super(priority: 1); // 매우 낮은 우선순위로 설정하여 터치 컨트롤러가 위에 그려지도록 함

  final PlayerStats playerStats;
  final Vector2 screenSize;
  final bool safeArea;

  late final TextComponent _scoreText;
  late final TextComponent _speedText;
  late final List<LifeIcon> _lifeIcons;

  // 점수 텍스트 애니메이션 관련 변수
  double _scoreTextScale = 1.0;
  double _scoreAnimTimer = 0.0;
  bool _scoreAnimActive = false;

  // 안전 영역 패딩 값 (iPhone notch/Dynamic Island와 같은 요소 고려)
  static const double safeAreaTopPadding = 30;
  static const double safeAreaSidePadding = 10;

  @override
  Future<void> onLoad() async {
    // 점수 텍스트 컴포넌트 - 더 작게 조정
    _scoreText = TextComponent(
      text: 'Score: 0',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10, // 더 작은 폰트 크기로 줄임
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

    // 속도 텍스트 컴포넌트 추가 - 더 작게 조정
    _speedText = TextComponent(
      text: 'Speed: x1.0',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.cyan,
          fontSize: 8, // 더 작은 폰트 크기로 줄임
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
          safeArea ? safeAreaTopPadding + 15 : 20), // 위치 조정
    );
    await add(_speedText);

    // 생명 아이콘 생성 - 속도 텍스트 아래에 배치
    final double heartY =
        (safeArea ? safeAreaTopPadding : 5) + 30; // 속도 텍스트 아래로 위치 조정

    _lifeIcons = List.generate(
      playerStats.maxLives,
      (index) => LifeIcon(
        position: Vector2(
            (safeArea ? safeAreaSidePadding : 5) +
                (index * 12), // 왼쪽부터 시작하여 간격 유지
            heartY),
        size: Vector2.all(12), // 크기 유지
      ),
    );

    for (final icon in _lifeIcons) {
      await add(icon);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 점수 업데이트 - 천 단위 구분 기호 추가
    String formattedScore = playerStats.score.toString();
    // 3자리마다 쉼표 추가 (천 단위 구분)
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

    // 속도 업데이트 (소수점 한 자리까지 표시)
    final speedFactor = playerStats.getSpeedFactor();
    _speedText.text = 'Speed: x${speedFactor.toStringAsFixed(1)}';

    // 속도에 따라 색상 변경
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

    // 점수 텍스트 애니메이션 업데이트
    if (_scoreAnimActive) {
      _scoreAnimTimer += dt;
      if (_scoreAnimTimer >= 0.5) {
        // 0.5초 후 애니메이션 종료
        _scoreAnimActive = false;
        _scoreTextScale = 1.0;
      } else {
        // 서서히 원래 크기로 돌아가기
        _scoreTextScale = 1.3 - (_scoreAnimTimer / 0.5) * 0.3;
      }
      // 텍스트 크기 적용
      _scoreText.scale = Vector2.all(_scoreTextScale);
    }

    // 생명 아이콘 업데이트 - 왼쪽부터 하트가 감소하도록 수정
    for (int i = 0; i < _lifeIcons.length; i++) {
      // 인덱스 변환: 왼쪽부터 감소하도록 변경
      final displayIndex = _lifeIcons.length - 1 - i;
      _lifeIcons[displayIndex].visible = i < playerStats.lives;
    }
  }
}

/// 생명 아이콘 컴포넌트
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
      // 하트 모양 컴포넌트가 있을 경우 가시성 업데이트
      if (_heart != null) {
        if (_visible) {
          _heart!.paint.color = const Color(0xFFFF0000); // 빨간색
        } else {
          _heart!.paint.color = const Color(0x33FF0000); // 투명한 빨간색
        }
      }
    }
  }

  @override
  bool get isVisible => true; // 항상 컴포넌트 자체는 보이게 설정

  @override
  Future<void> onLoad() async {
    // 하트 모양 생성
    _heart = HeartComponent(
      size: Vector2.all(10), // 하트 크기 줄임 (15 -> 10)
      paint: Paint()..color = Colors.red,
    );

    await add(_heart!);

    // 초기 가시성 설정
    visible = _visible;
  }
}

/// 하트 모양 컴포넌트
class HeartComponent extends PositionComponent {
  HeartComponent({
    required Vector2 size,
    required this.paint,
  }) : super(size: size);

  final Paint paint;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 하트 모양 그리기
    final Path path = Path();

    // 하트 크기
    final double width = size.x;
    final double height = size.y;

    // 하트를 그리기 위한 기준점
    final double x = width / 2;
    final double y = height / 2;

    // 시작점 설정
    path.moveTo(x, y + height / 3);

    // 하트 왼쪽 부분
    path.cubicTo(
        x - width / 2,
        y, // 첫 번째 제어점
        x - width / 2,
        y - height / 2, // 두 번째 제어점
        x,
        y - height / 4 // 종료점
        );

    // 하트 오른쪽 부분
    path.cubicTo(
        x + width / 2,
        y - height / 2, // 첫 번째 제어점
        x + width / 2,
        y, // 두 번째 제어점
        x,
        y + height / 3 // 종료점 (시작점과 동일)
        );

    // 경로 닫기
    path.close();

    // 캔버스에 하트 그리기
    canvas.drawPath(path, paint);
  }
}
