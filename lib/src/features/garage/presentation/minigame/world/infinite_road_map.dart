import 'dart:async';
import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

/// 무한 스크롤 도로 맵을 구현하는 컴포넌트
class InfiniteRoadMap extends Component {
  InfiniteRoadMap({
    this.visibleSegments = 2,
    this.maxSegments = 4,
  });

  /// 화면에 동시에 보여질 맵 세그먼트 수
  final int visibleSegments;

  /// 최대 맵 세그먼트 수 (메모리 관리용)
  final int maxSegments;

  /// 도로 관련 속성
  double get roadWidth => 64.0;
  double get roadStartX => (800 - roadWidth) / 2;
  double get roadCenter => roadStartX + roadWidth / 2;

  /// 현재 로드된 맵 세그먼트들
  final Queue<_MapSegment> _segments = Queue<_MapSegment>();

  /// 각 세그먼트의 높이
  double _segmentHeight = 52 * 16.0;

  /// 추적할 플레이어 컴포넌트
  PositionComponent? _target;

  /// 플레이어 컴포넌트를 추적하도록 설정
  void setTarget(PositionComponent target) {
    _target = target;
  }

  @override
  Future<void> onLoad() async {
    // 기본 맵 생성
    createBasicMap();
  }

  @override
  void update(double dt) {
    if (_target == null) return;

    // 플레이어가 현재 보이는 세그먼트의 중간쯤에 도달하면 새 세그먼트 추가
    final targetY = _target!.position.y;
    final lastSegmentY = _segments.isEmpty ? 0 : _segments.last.position.y;

    // 마지막 세그먼트의 끝부분이 플레이어 위치 + 일정 거리보다 작으면 새 세그먼트 추가
    if (_segments.isEmpty ||
        lastSegmentY + _segmentHeight < targetY + _segmentHeight * 1.5) {
      _addNewSegment();
    }

    // 너무 많은 세그먼트가 로드되면 오래된 세그먼트 제거
    while (_segments.length > maxSegments) {
      final oldestSegment = _segments.removeFirst();
      remove(oldestSegment);
    }
  }

  /// 새 맵 세그먼트를 추가
  Future<void> _addNewSegment() async {
    final double newY =
        _segments.isEmpty ? 0.0 : _segments.last.position.y + _segmentHeight;

    final segment = await _createBasicSegment(newY);
    _segments.add(segment);
  }

  void createBasicMap() {
    // 기본 맵 생성
    _createBasicSegment(0);

    // 필요한 만큼 추가 세그먼트 로드
    for (int i = 1; i < visibleSegments; i++) {
      _createBasicSegment(i * _segmentHeight);
    }
  }

  Future<_MapSegment> _createBasicSegment(double yPosition) async {
    // 기본 세그먼트 생성
    final placeholder =
        PlaceholderTiledComponent(size: Vector2(800, _segmentHeight));
    final segment = _MapSegment(placeholder, yPosition);
    await add(segment);
    return segment;
  }
}

/// 맵 세그먼트를 나타내는 내부 클래스
class _MapSegment extends PositionComponent {
  _MapSegment(this.map, double yPosition) {
    position.y = yPosition;
  }

  final Component map;

  @override
  Future<void> onLoad() async {
    await add(map);
  }
}

/// 로드 실패 시 사용할 임시 도로 컴포넌트
class PlaceholderTiledComponent extends PositionComponent {
  PlaceholderTiledComponent({required Vector2 size}) {
    this.size = size;
  }

  // 맵의 크기를 명시적으로 노출
  double get mapHeight => size.y;

  /// 잔디 패턴을 위한 색상 목록
  final List<Color> _grassColors = [
    const Color(0xFF3D7E2E), // 더 진한 초록
    const Color(0xFF5CAE4A), // 더 밝은 초록
    const Color(0xFF4C9E39), // 기본 초록
    const Color(0xFF3D8E2E), // 약간 진한 초록
    const Color(0xFF5CBE4A), // 약간 밝은 초록
  ];

  /// 잔디 패턴 생성
  List<RectangleComponent> _createGrassPatterns() {
    final patterns = <RectangleComponent>[];
    final roadWidth = 64.0;
    final roadStartX = (size.x - roadWidth) / 2;

    // 도로 주변 영역 계산
    final roadLeft = roadStartX - 100;
    final roadRight = roadStartX + roadWidth + 100;

    // 패턴이 세그먼트 경계를 넘어서도 생성되도록 여유 공간 추가
    final extraHeight = size.y * 0.2; // 세그먼트 높이의 20%만큼 여유 공간
    final spacing = 10.0; // 패턴 간격을 더 줄임

    // 패턴 개수 계산 (더 조밀하게)
    final patternsPerRow = ((roadRight - roadLeft) / spacing).ceil();
    final patternsPerCol = ((size.y + extraHeight * 2) / spacing).ceil();
    final totalPatterns = patternsPerRow * patternsPerCol;

    for (int i = 0; i < totalPatterns; i++) {
      final color = _grassColors[i % _grassColors.length];
      final patternSize = Vector2(
        3 + (i % 3) * 2, // 더 작은 크기로 조정
        3 + (i % 3) * 2,
      );

      // 격자 기반 위치 계산으로 변경
      final row = i ~/ patternsPerRow;
      final col = i % patternsPerRow;

      final x = roadLeft + col * spacing;
      final y = row * spacing - extraHeight;

      // 시작 부분과 끝 부분에서 자연스럽게 이어지도록 조정
      if (y >= -extraHeight && y <= size.y + extraHeight) {
        final position = Vector2(x, y);

        // 도로 영역에 패턴이 생성되지 않도록 체크
        if (x < roadStartX - 5 || x > roadStartX + roadWidth + 5) {
          patterns.add(RectangleComponent(
            position: position,
            size: patternSize,
            paint: Paint()
              ..color = color
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
          ));
        }
      }
    }
    return patterns;
  }

  @override
  Future<void> onLoad() async {
    // 기본 잔디 배경 (진한 초록색)
    final grassBackground = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF4C9E39),
    );
    await add(grassBackground);

    // 잔디 패턴 추가
    final grassPatterns = _createGrassPatterns();
    for (final pattern in grassPatterns) {
      await add(pattern);
    }

    // 도로 (어두운 회색)
    final roadWidth = 64.0;
    final roadStartX = (size.x - roadWidth) / 2;
    final road = RectangleComponent(
      position: Vector2(roadStartX, 0),
      size: Vector2(roadWidth, size.y),
      paint: Paint()..color = const Color(0xFF666666),
    );
    await add(road);

    // 도로 중앙 노란색 점선
    final dotCount = (size.y / 20).ceil();
    for (int i = 0; i < dotCount; i++) {
      if (i % 2 == 0) {
        final dot = RectangleComponent(
          position: Vector2(size.x / 2 - 1, i * 20.0),
          size: Vector2(2, 10),
          paint: Paint()..color = const Color(0xFFFFFF00),
        );
        await add(dot);
      }
    }
  }
}
