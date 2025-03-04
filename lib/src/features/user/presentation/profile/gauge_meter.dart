import 'dart:math';

import 'package:flutter/material.dart';

class GaugeMeter extends StatelessWidget {
  final int points;

  const GaugeMeter({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: GaugePainter(points: points),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "POINTS",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 68),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: points
                    .toString()
                    .split('')
                    .map(
                      (digit) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          digit,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GaugePainter extends CustomPainter {
  final int points;

  GaugePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    const startAngle = pi * 0.9;
    const sweepAngle = pi * 1.2;

    final paintArc = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    // Draw border
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paintArc,
    );

    // Draw tick marks
    for (int i = 0; i <= 8; i++) {
      double tickAngle = startAngle + (sweepAngle / 8) * i;
      Offset start;
      Offset end;

      if (i == 0 || i == 8) {
        // First and last tick should be brought down a bit ("5")
        start = center +
            Offset(cos(tickAngle) * (radius - 20),
                sin(tickAngle) * (radius - 20) + 5);
      } else {
        start = center +
            Offset(
                cos(tickAngle) * (radius - 20), sin(tickAngle) * (radius - 20));
      }

      if (i == 0 || i == 8) {
        // First and last tick should be flat
        end = start + Offset(20 * (i == 0 ? -1 : 1), 0);
      } else {
        end = center + Offset(cos(tickAngle) * radius, sin(tickAngle) * radius);
      }

      Paint tickPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 4;

      canvas.drawLine(start, end, tickPaint);
    }

    // Draw needle
    Paint needlePaint = Paint()
      ..color = const Color(0xFFE85B81)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    const rangeSize = 10000;

    // Calculate the range the current points belong to
    int rangeIndex = points ~/ rangeSize;
    double minPoints = (rangeIndex * rangeSize).toDouble();
    double maxPoints = minPoints + rangeSize.toDouble();

    // Normalize points within the current range (0.0 to 1.0)
    double normalizedPoints =
        ((points - minPoints) / (maxPoints - minPoints)).clamp(0.0, 1.0);

    double needleAngle = startAngle + (sweepAngle * normalizedPoints);

    Offset needleEnd = center +
        Offset(
            cos(needleAngle) * (radius - 32), sin(needleAngle) * (radius - 32));

    canvas.drawLine(center, needleEnd, needlePaint);

    // Draw center circle
    final Paint centerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 10, centerCirclePaint);

    // Draw levels
    Offset startPoint =
        center + Offset(cos(startAngle) * radius, sin(startAngle) * radius);
    Offset endPoint = center +
        Offset(
          cos(startAngle + sweepAngle) * radius,
          sin(startAngle + sweepAngle) * radius,
        );

    _drawText(
      canvas,
      (points / 10000).floor().toString(),
      startPoint + const Offset(0, 20),
    );
    _drawText(
      canvas,
      ((points / 10000).floor() + 1).toString(),
      endPoint + const Offset(0, 20),
    );
  }

  // PRIVATE
  void _drawText(Canvas canvas, String text, Offset position) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final offset = position -
        Offset(
          textPainter.width / 2,
          textPainter.height / 2 - 12,
        );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
