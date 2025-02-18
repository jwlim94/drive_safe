import 'package:drive_safe/src/features/home/domain/drive.dart';
import 'package:drive_safe/src/features/home/presentation/providers/last_drive_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String state = 'Stopped';
  String titleText = 'Last';
  String buttonText = 'Start';
  String pauseButtonText = 'Pause';
  int lastAwardedMinute = 0; // Store the last minute when a point was awarded
  final stopWatch = Stopwatch();
  late Timer timer;
  double buttonSize = 100;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (stopWatch.isRunning) {
          updateElapsedEarnings();
        }
      });
    });
  }

  void startDrive() {
    if (state == 'Stopped') {
      // Reset lastDrive when starting a new drive
      ref.read(lastDriveNotifierProvider.notifier).addLastDrive(
            Drive(points: 0, timeElapsed: Duration.zero, getAchievement: true),
          );

      setState(() {
        pauseButtonText = 'Pause';
        titleText = 'This';
        buttonText = 'End';
        state = 'Started';
        buttonSize = 20;
      });

      stopWatch.start();
      updateElapsedEarnings();
    } else {
      // Persist drive when stopping
      stopWatch.stop();
      stopWatch.reset();

      setState(() {
        titleText = 'Last';
        buttonText = 'Start';
        state = 'Stopped';
        buttonSize = 100;
      });

      // Navigate if achievement is earned
      final lastDrive = ref.read(lastDriveNotifierProvider);
      if (lastDrive.getAchievement) {
        context.go('/achievements');
      }
    }
  }

  void pauseDrive() {
    if (pauseButtonText == 'Pause') {
      setState(() {
        pauseButtonText = 'Resume';
      });
      stopWatch.stop();
    } else {
      setState(() {
        pauseButtonText = 'Pause';
      });
      stopWatch.start();
    }

    updateElapsedEarnings();
  }

  void updateElapsedEarnings() {
    final lastDrive = ref.read(lastDriveNotifierProvider);

    final updatedDrive = lastDrive.copyWith(
      timeElapsed: stopWatch.elapsed,
      points: (stopWatch.elapsed.inMinutes >= lastAwardedMinute + 5)
          ? lastDrive.points + 1
          : lastDrive.points,
    );

    if (updatedDrive.points > lastDrive.points) {
      lastAwardedMinute = updatedDrive.timeElapsed.inMinutes;
    }

    ref.read(lastDriveNotifierProvider.notifier).addLastDrive(updatedDrive);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lastDrive = ref.watch(lastDriveNotifierProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(
                'Points $titleText Drive',
                textAlign: TextAlign.center,
                style: TextStyles.h2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (lastDrive.points > 99)
                  _buildPointContainer((lastDrive.points ~/ 100).toString()),
                _buildPointContainer(
                    ((lastDrive.points ~/ 10) % 10).toString()),
                _buildPointContainer(((lastDrive.points ~/ 1) % 10).toString()),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                'Safe Minutes: ${lastDrive.timeElapsed.inMinutes}m ${lastDrive.timeElapsed.inSeconds.remainder(60)}s',
                textAlign: TextAlign.center,
                style: TextStyles.bodyMedium,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (state == 'Started')
                Padding(
                  padding: const EdgeInsets.only(top: 40, right: 10),
                  child: Center(
                    child: CustomButton(
                      text: '$pauseButtonText Drive',
                      onPressed: pauseDrive,
                      horizontalPadding: 10,
                      borderOutline: AppColors.customPink,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: CustomButton(
                    text: '$buttonText Drive',
                    onPressed: startDrive,
                    horizontalPadding: buttonSize,
                    backgroundColor: AppColors.customPink,
                  ),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }

  Widget _buildPointContainer(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.customLightGray, width: 2),
      ),
      child: Text(
        text,
        style: TextStyles.xlText,
      ),
    );
  }
}
