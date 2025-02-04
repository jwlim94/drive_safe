import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String state = 'Stopped';
  String titleText = 'Last';
  String buttonText = 'Start';
  String pauseButtonText = 'Pause';
  int points = 0; //How about 1 point for every 5 safe minutes??
  int lastAwardedMinute = 0; //Store the last minute when a point was awarded
  Duration timeElapsed = Duration.zero;
  final stopWatch = Stopwatch();
  late Timer timer;

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
        timeElapsed = Duration.zero;
        points = 0;
        pauseButtonText = 'Pause';
        titleText = 'This';
        buttonText = 'Finish';
        state = 'Started';
      });
      stopWatch.start();
      updateElapsedEarnings();
    } else {
      setState(() {
        titleText = 'Last';
        buttonText = 'Start';
        state = 'Stopped';
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
      timeElapsed = stopWatch.elapsed;
      if (timeElapsed.inMinutes >= lastAwardedMinute + 5) {
        points += 1;
        lastAwardedMinute = timeElapsed.inMinutes;
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
              if (points > 99)
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.customLightGray, width: 2)),
                  child: Text(
                    (points ~/ 100).toString(),
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
                  ((points ~/ 10) % 10).toString(),
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
                  ((points ~/ 1) % 10).toString(),
                  style: TextStyles.xlText,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              'Safe Minutes: ${timeElapsed.inMinutes}m ${timeElapsed.inSeconds.remainder(60)}s', //insert dynamic minutes and seconds later
              textAlign: TextAlign.center,
              style: TextStyles.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: CustomButton(
                text: '$buttonText Drive',
                onPressed: () => startDrive(),
                horizontalPadding: 115,
                backgroundColor: AppColors.customPink,
              ),
            ),
          ),
          if (state == 'Started')
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: CustomButton(
                  text: '$pauseButtonText Drive',
                  onPressed: () => pauseDrive(),
                  horizontalPadding: 115,
                  backgroundColor: AppColors.customPink,
                ),
              ),
            ),
        ],
      ),
    ));
  }
}
