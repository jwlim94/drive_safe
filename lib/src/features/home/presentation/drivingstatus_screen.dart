import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DrivingStatusScreen extends StatelessWidget {
  const DrivingStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.customWhite,
      body: Column(
        children: [
          _buildCurvedHeader(),
          const SizedBox(height: 20),
          _safeMinutesDisplay(),
          const SizedBox(height: 20),
          _pointsEarnedDisplay(),
          const SizedBox(height: 20),
          _progressBar(),
        ],
      ),
    );
  }

  /// 🚗 **체크무늬 배경이 적용된 헤더**
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 150, // 원하는 높이로 조절 가능
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/checkered_flag.png"), // 🔥 이미지 경로 지정
          fit: BoxFit.cover, // 배경을 꽉 채우도록 설정
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: const Center(
        child: Text(
          "Drive Summary",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// 🚗 **안전 시간 표시하는 원**
  Widget _safeMinutesDisplay() {
    return Column(
      children: [
        SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(220, 220),
                painter: GradientCirclePainter(),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SAFE MINUTES",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "160",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 🏆 **포인트 표시**
  Widget _pointsEarnedDisplay() {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: "2,000 ",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          TextSpan(
            text: "Points Earned",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// 📈 **진행률 바**
  Widget _progressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: 10000 / 13000,
            backgroundColor: Colors.grey[300],
            color: AppColors.customPink,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 5),
          const Text(
            "10000/13000",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// 🎨 **곡선 헤더 클리퍼**
class CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height + 50, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// 🎨 **그라데이션 적용된 원을 그리는 커스텀 페인터**
class GradientCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const SweepGradient(
        colors: [Colors.greenAccent, Colors.blue, Colors.greenAccent], // 그라데이션
        startAngle: 0.0,
        endAngle: 6.28, // 360도 (2 * pi)
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 7.5;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
