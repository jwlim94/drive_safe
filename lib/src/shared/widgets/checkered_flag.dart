import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CheckeredFlag extends StatelessWidget {
  const CheckeredFlag({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: SvgPicture.asset(
        'assets/images/checkered_flag.svg',
        fit: BoxFit.cover,
      ),
    );
  }
}
