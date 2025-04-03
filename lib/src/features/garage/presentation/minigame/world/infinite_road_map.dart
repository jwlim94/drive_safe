import 'dart:async';
import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

class InfiniteRoadMap extends Component {
  InfiniteRoadMap({
    this.visibleSegments = 2,
    this.maxSegments = 4,
  });

  final int visibleSegments;

  final int maxSegments;

  double get roadWidth => 64.0;
  double get roadStartX => (800 - roadWidth) / 2;
  double get roadCenter => roadStartX + roadWidth / 2;

  final Queue<_MapSegment> _segments = Queue<_MapSegment>();

  double _segmentHeight = 52 * 16.0;

  PositionComponent? _target;

  void setTarget(PositionComponent target) {
    _target = target;
  }

  @override
  Future<void> onLoad() async {
    createBasicMap();
  }

  @override
  void update(double dt) {
    if (_target == null) return;

    final targetY = _target!.position.y;
    final lastSegmentY = _segments.isEmpty ? 0 : _segments.last.position.y;

    if (_segments.isEmpty ||
        lastSegmentY + _segmentHeight < targetY + _segmentHeight * 1.5) {
      _addNewSegment();
    }

    while (_segments.length > maxSegments) {
      final oldestSegment = _segments.removeFirst();
      remove(oldestSegment);
    }
  }

  Future<void> _addNewSegment() async {
    final double newY =
        _segments.isEmpty ? 0.0 : _segments.last.position.y + _segmentHeight;

    final segment = await _createBasicSegment(newY);
    _segments.add(segment);
  }

  void createBasicMap() {
    _createBasicSegment(0);

    for (int i = 1; i < visibleSegments; i++) {
      _createBasicSegment(i * _segmentHeight);
    }
  }

  Future<_MapSegment> _createBasicSegment(double yPosition) async {
    final placeholder =
        PlaceholderTiledComponent(size: Vector2(800, _segmentHeight));
    final segment = _MapSegment(placeholder, yPosition);
    await add(segment);
    return segment;
  }
}

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

class PlaceholderTiledComponent extends PositionComponent {
  PlaceholderTiledComponent({required Vector2 size}) {
    this.size = size;
  }

  double get mapHeight => size.y;

  final List<Color> _grassColors = [
    const Color(0xFF3D7E2E),
    const Color(0xFF5CAE4A),
    const Color(0xFF4C9E39),
    const Color(0xFF3D8E2E),
    const Color(0xFF5CBE4A),
  ];

  List<RectangleComponent> _createGrassPatterns() {
    final patterns = <RectangleComponent>[];
    final roadWidth = 64.0;
    final roadStartX = (size.x - roadWidth) / 2;

    final roadLeft = roadStartX - 100;
    final roadRight = roadStartX + roadWidth + 100;

    final extraHeight = size.y * 0.2;
    final spacing = 10.0;

    final patternsPerRow = ((roadRight - roadLeft) / spacing).ceil();
    final patternsPerCol = ((size.y + extraHeight * 2) / spacing).ceil();
    final totalPatterns = patternsPerRow * patternsPerCol;

    for (int i = 0; i < totalPatterns; i++) {
      final color = _grassColors[i % _grassColors.length];
      final patternSize = Vector2(
        3 + (i % 3) * 2,
        3 + (i % 3) * 2,
      );

      final row = i ~/ patternsPerRow;
      final col = i % patternsPerRow;

      final x = roadLeft + col * spacing;
      final y = row * spacing - extraHeight;

      if (y >= -extraHeight && y <= size.y + extraHeight) {
        final position = Vector2(x, y);

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
    final grassBackground = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF4C9E39),
    );
    await add(grassBackground);

    final grassPatterns = _createGrassPatterns();
    for (final pattern in grassPatterns) {
      await add(pattern);
    }

    const roadWidth = 64.0;
    final roadStartX = (size.x - roadWidth) / 2;
    final road = RectangleComponent(
      position: Vector2(roadStartX, 0),
      size: Vector2(roadWidth, size.y),
      paint: Paint()..color = const Color(0xFF666666),
    );
    await add(road);

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
