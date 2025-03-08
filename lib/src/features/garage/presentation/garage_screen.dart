import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class GarageScreen extends StatelessWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'garage screen',
        ),
        const SizedBox(
          height: 50,
        ),
        CustomButton(
          text: 'Race!',
          onPressed: () => context.go('/garage/minigame'),
        )
      ],
    );
  }
}
