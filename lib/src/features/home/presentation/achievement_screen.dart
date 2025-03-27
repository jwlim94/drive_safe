import 'package:drive_safe/src/features/home/presentation/providers/session_provider.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_drive_streak_badge_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_drive_points_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_drive_streak_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_endurance_minutes_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_last_drive_streak_at_controller.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/checkered_flag.dart';
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
    ref.watch(sessionNotifierProvider);
    ref.watch(updateUserDriveStreakControllerProvider);
    ref.watch(updateUserLastDriveStreakAtControllerProvider);
    ref.watch(updateUserDrivePointsControllerProvider);
    ref.watch(updateUserEnduranceMinutesControllerProvider);
    ref.watch(updateDriveStreakBadgeControllerProvider);
    final currentUser = ref.watch(currentUserStateProvider);
    final currentSession = ref.watch(sessionNotifierProvider);

    // TODO: handle loading state
    if (currentUser == null) return Container();

    if (state == 'Streak') {
      return Stack(
        children: [
          const CheckeredFlag(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                const Padding(padding: EdgeInsets.only(top: 75)),
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
                      padding: EdgeInsets.only(bottom: 20, top: 150),
                      child: Text(
                        'Your Focus Streak!',
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
                                currentUser.driveStreak.toString(),
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
                        'You have completed ${currentUser.driveStreak.toString()} daily goals in a row! \n Let\'s see what that does for your progress!',
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
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          const CheckeredFlag(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 5, top: 150),
                    child: Text(
                      'Achievements Earned!',
                      style: TextStyles.h3,
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(), // Prevent nested scrolling
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 items per row
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.2, // Adjust as needed
                          ),
                          itemCount: currentSession.sessionBadges.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Image.asset(
                                  'assets/images/badges/${currentSession.sessionBadges[index].toString().split("_")[0]}/${currentSession.sessionBadges[index].toString().split("_")[1]}_unlocked.png',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                                // Conditional text display
                                if (currentSession.sessionBadges[index]
                                        .toString()
                                        .split("_")[0] ==
                                    "endurance")
                                  Text(
                                    '${currentSession.sessionBadges[index].toString().split("_")[1]} daily minutes!',
                                    style: TextStyles.bodyMedium,
                                  )
                                else if (currentSession.sessionBadges[index]
                                        .toString()
                                        .split("_")[0] ==
                                    "hotstreak")
                                  Text(
                                    '${currentSession.sessionBadges[index].toString().split("_")[1]} streak!',
                                    style: TextStyles.bodyMedium,
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Add spacing before buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 20),
                        child: CustomButton(
                          text: 'Back',
                          onPressed: () => previousState(),
                          horizontalPadding: 50,
                          backgroundColor: Colors.transparent,
                          borderOutline: AppColors.customPink,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: CustomButton(
                          text: 'Finish',
                          onPressed: () => nextState(),
                          horizontalPadding: 50,
                          backgroundColor: AppColors.customPink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // Keeps some space at the bottom
                ],
              ),
            ]),
          ),
        ],
      );
    }
  }
}
