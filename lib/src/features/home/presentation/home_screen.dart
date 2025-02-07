import 'package:drive_safe/src/features/home/domain/drive.dart';
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
  Drive driveObject =
      Drive(points: 0, timeElapsed: Duration.zero, getAchievement: true);
  String state = 'Stopped';
  String titleText = 'Last';
  String buttonText = 'Start';
  String pauseButtonText = 'Pause';
  int lastAwardedMinute = 0; //Store the last minute when a point was awarded
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
      setState(() {
        driveObject.timeElapsed = Duration.zero;
        driveObject.points = 0;
        pauseButtonText = 'Pause';
        titleText = 'This';
        buttonText = 'End';
        state = 'Started';
        buttonSize = 40;
      });
      stopWatch.start();
      updateElapsedEarnings();
    } else {
      setState(() {
        titleText = 'Last';
        buttonText = 'Start';
        state = 'Stopped';
        buttonSize = 100;
        //persist information from last drive
        //ref.read(pointsTimeProvider.notifier).updatePoints(driveObject);
        if (driveObject.getAchievement) {
          //Eventually, this will be a method that returns an achievement object (if it is empty, then do not show the next pages)
          context.go('/achievements');
        }
      });
      stopWatch.stop();
      stopWatch.reset();
    }
  }

  void pauseDrive() {
    if (pauseButtonText == 'Pause') {
      setState(() {
        pauseButtonText = 'Resume';
      });
      stopWatch.stop();
      updateElapsedEarnings();
    } else {
      setState(() {
        pauseButtonText = 'Pause';
      });
      stopWatch.start();
      updateElapsedEarnings();
    }
  }

  void updateElapsedEarnings() {
    setState(() {
      driveObject.timeElapsed = stopWatch.elapsed;
      if (driveObject.timeElapsed.inMinutes >= lastAwardedMinute + 5) {
        driveObject.points += 1;
        lastAwardedMinute = driveObject.timeElapsed.inMinutes;
      }
    });
  }

  //Resource cleanup on widget tree 'destruction'
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Text(
              'Points $titleText Drive',
              textAlign: TextAlign.center,
              style: TextStyles.h2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //insert dynamic numbers later
              if (driveObject.points > 99)
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.customLightGray, width: 2)),
                  child: Text(
                    (driveObject.points ~/ 100).toString(),
                    style: TextStyles.xlText,
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(right: 5),
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: AppColors.customLightGray, width: 2)),
                child: Text(
                  ((driveObject.points ~/ 10) % 10).toString(),
                  style: TextStyles.xlText,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5),
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: AppColors.customLightGray, width: 2)),
                child: Text(
                  ((driveObject.points ~/ 1) % 10).toString(),
                  style: TextStyles.xlText,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              'Safe Minutes: ${driveObject.timeElapsed.inMinutes}m ${driveObject.timeElapsed.inSeconds.remainder(60)}s', //insert dynamic minutes and seconds later
              textAlign: TextAlign.center,
              style: TextStyles.bodyMedium,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (state == 'Started')
              Padding(
                padding: const EdgeInsets.only(top: 30, right: 20),
                child: Center(
                  child: CustomButton(
                    text: '$pauseButtonText Drive',
                    onPressed: () => pauseDrive(),
                    horizontalPadding: 40,
                    borderOutline: AppColors.customPink,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: CustomButton(
                  text: '$buttonText Drive',
                  onPressed: () => startDrive(),
                  horizontalPadding: buttonSize,
                  backgroundColor: AppColors.customPink,
                ),
              ),
            ),
          ])
        ],
      ),
    ));
  }
}
