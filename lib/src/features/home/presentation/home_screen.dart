import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';

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
  Duration timeElapsed = Duration.zero;
  final stopWatch = Stopwatch();

  void startDrive() {
    if (state == 'Stopped') {
      setState(() {
        timeElapsed = Duration.zero;
        pauseButtonText = 'Pause';
        titleText = 'This';
        buttonText = 'Finish';
        state = 'Started';
      });
      stopWatch.start();
    } else {
      setState(() {
        titleText = 'Last';
        buttonText = 'Start';
        state = 'Stopped';
        timeElapsed = stopWatch.elapsed;
      });
      stopWatch.reset();
    }
  }

  void pauseDrive() {
    if (pauseButtonText == 'Pause') {
      setState(() {
        pauseButtonText = 'Resume';
        timeElapsed = stopWatch.elapsed;
      });
      stopWatch.stop();
    } else {
      setState(() {
        pauseButtonText = 'Pause';
      });
      stopWatch.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.customBlack,
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
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.customLightGray, width: 2)),
                    child: const Text(
                      '5',
                      style: TextStyles.xlText,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.customLightGray, width: 2)),
                    child: const Text(
                      '6',
                      style: TextStyles.xlText,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  'Safe Minutes: ${timeElapsed.inMinutes}m ${timeElapsed.inSeconds}s', //insert dynamic minutes and seconds later
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
