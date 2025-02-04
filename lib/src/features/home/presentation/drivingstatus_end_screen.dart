import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrivingStatusEndScreen extends StatelessWidget {
  const DrivingStatusEndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildPointsDisplay(),
          const SizedBox(height: 10),
          _buildSafeMinutes(),
          const SizedBox(height: 30),
          _buildEndButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/checkered_flag.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPointsDisplay() {
    return Column(
      children: [
        const SizedBox(height: 80),
        const Text(
          "Points Last Drive",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 70),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberBox("5"),
            const SizedBox(width: 10),
            _buildNumberBox("6"),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberBox(String number) {
    return Container(
      width: 90,
      height: 140,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 34, 34, 34),
        border: Border.all(color: Colors.white, width: 2.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 78,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSafeMinutes() {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        "Safe Minutes: 15m 30s",
        style: TextStyle(fontSize: 16, color: Colors.white70),
      ),
    );
  }

  /// 🚗 End Drive button → Home
  Widget _buildEndButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.customPink,
        padding: const EdgeInsets.symmetric(horizontal: 102, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        context.go('/home');
      },
      child: const Text(
        "End Drive",
        style: TextStyle(
            fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
