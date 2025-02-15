import 'package:drive_safe/src/features/home/presentation/providers/last_drive_provider.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';

class AchievementScreen extends ConsumerStatefulWidget {
  const AchievementScreen({super.key});

  @override
  ConsumerState<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends ConsumerState<AchievementScreen> {
  int consecutiveSafeDrives = 0; //Get this from the repo layer later...
  String state = 'Streak';
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
    final lastDrive = ref.watch(lastDriveNotifierProvider);
    final currentUser = ref.watch(currentUserStateProvider);

    if (state == 'Streak') {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          flexibleSpace: Align(
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(
              'assets/images/checkered_flag.svg',
              width: double.infinity,
              fit: BoxFit.cover,
              height: 75,
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          flexibleSpace: Align(
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(
              'assets/images/checkered_flag.svg',
              width: double.infinity,
              fit: BoxFit.cover,
              height: 75,
            ),
          ),
        ),
        body: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                      color: Color(currentUser?.primaryColor.toUnsigned(32) ??
                          0xFF2196F3),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Text(
                          currentUser?.name[0] ?? "?",
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
