import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({
    super.key,
    required this.musicValueListenable,
    required this.sfxValueListenable,
    this.onBackPressed,
    this.onMusicValueChanged,
    this.onSfxValueChanged,
  });

  final ValueListenable<bool> musicValueListenable;
  final ValueListenable<bool> sfxValueListenable;
  final VoidCallback? onBackPressed;
  final ValueChanged<bool>? onMusicValueChanged;
  final ValueChanged<bool>? onSfxValueChanged;

  static const id = 'Settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: onBackPressed,
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const Text('Settings', style: TextStyles.h2),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: ValueListenableBuilder<bool>(
                valueListenable: musicValueListenable,
                builder: (context, value, child) {
                  return SwitchListTile(
                    value: value,
                    title: child,
                    onChanged: onMusicValueChanged,
                  );
                },
                child: const Text('Music', style: TextStyles.h4),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 200,
              child: ValueListenableBuilder<bool>(
                valueListenable: sfxValueListenable,
                builder: (context, value, child) {
                  return SwitchListTile(
                    value: value,
                    title: child,
                    onChanged: onSfxValueChanged,
                  );
                },
                child: const Text('Sfx', style: TextStyles.h4),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
