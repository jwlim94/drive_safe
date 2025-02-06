import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  int consecutiveSafeDrives = 0; //Get this from the repo layer later...
  String state = 'Streak';
  Color profileColor =
      Colors.lightGreen; //Get this from the repo layer later...
  String firstInitial = 'J'; //Get this from the repo layer later...
  late ConfettiController _controllerTopCenter; //just for fun!
  bool triggerConfetti = true;

  @override
  void initState() {
    super.initState();
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 3));
    if (triggerConfetti) {
      _controllerTopCenter.play();
      triggerConfetti = false;
    }
  }

  void nextState() {
    setState(() {
      if (state == 'Streak') {
        state = 'AchievementProgress';
      } else if (state != 'Streak') {
        state = 'Streak';
        context.go('/home');
      }
    });
  }

  void previousState() {
    setState(() {
      if (state != 'Streak') {
        state = 'Streak';
      }
    });
  }

  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (state == 'Streak') {
      return Scaffold(
        body: Stack(
          children: [
            SvgPicture.asset(
              'assets/images/checkered_flag.svg',
              height: 75,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ConfettiWidget(
                    confettiController: _controllerTopCenter,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [
                      AppColors.customWhite,
                      AppColors.customLightBlack,
                      AppColors.customBlack,
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Your Safe Drive Streak!',
                    style: TextStyles.h3,
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/flame.svg',
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: -15,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(
                          child: Text(
                            consecutiveSafeDrives.toString(),
                            style: TextStyles.h2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'You have completed ${consecutiveSafeDrives.toString()} rides in a row! \n Let\'s see what that does for your progress!',
                    style: TextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: CustomButton(
                      text: 'Continue',
                      onPressed: () => nextState(),
                      horizontalPadding: 100,
                      backgroundColor: AppColors.customPink,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Stack(children: [
          SvgPicture.asset(
            'assets/images/checkered_flag.svg',
            height: 75,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Achievements Earned!',
                  style: TextStyles.h3,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      color: profileColor,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Text(
                          firstInitial,
                          style: TextStyles.h1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'List of Achievements here:',
                  style: TextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, right: 20),
                    child: Center(
                      child: CustomButton(
                        text: 'Back',
                        onPressed: () => previousState(),
                        horizontalPadding: 50,
                        backgroundColor: Colors.transparent,
                        borderOutline: AppColors.customPink,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Center(
                      child: CustomButton(
                        text: 'Finish',
                        onPressed: () => nextState(),
                        horizontalPadding: 50,
                        backgroundColor: AppColors.customPink,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]),
      );
    }
  }
}
