import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  final double width;

  const CustomTabIndicator({required this.width});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(width);
  }
}

class _CustomPainter extends BoxPainter {
  final double width;

  _CustomPainter(this.width);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = AppColors.customBlue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double xCenter = offset.dx + (configuration.size!.width / 2);
    double yBottom = offset.dy + configuration.size!.height + 12;

    canvas.drawLine(
      Offset(xCenter - (width / 2), yBottom),
      Offset(xCenter + (width / 2), yBottom),
      paint,
    );
  }
}
