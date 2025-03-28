import 'dart:io';

import 'package:drive_safe/src/features/home/application/daily_goal_service.dart';
import 'package:drive_safe/src/features/home/domain/session.dart';
import 'package:drive_safe/src/features/home/presentation/controllers/update_daily_goal_controller.dart';
import 'package:drive_safe/src/features/home/presentation/providers/session_provider.dart';
import 'package:drive_safe/src/features/leaderboard/presentation/controllers/update_user_league_status_controller.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_drive_streak_badge_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_drive_points_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_drive_streak_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_endurance_minutes_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_last_drive_streak_at_controller.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:drive_safe/src/routing/providers/scaffold_with_nested_navigation_visibility_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/numbers.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/checkered_flag.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:kiosk_mode/kiosk_mode.dart';

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
  late final Stream<KioskMode> _currentMode = watchKioskMode();
  bool isDailyGoalSet = false;

  @override
  void initState() {
    super.initState();

    final currentUser = ref.read(currentUserStateProvider);

    // If the user needs to set a new goal, then make them do so...
    if (currentUser != null) {
      final nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
      if (!userMetGoalInTime(currentUser.goalCompleteByTime, nowTimeStamp)) {
        ref.read(currentUserStateProvider.notifier).updateUserGoalByTime(0);
        ref.read(currentUserStateProvider.notifier).updateUserGoal(0);
      }
    }

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (stopWatch.isRunning) {
          updateElapsedEarnings();
        }
      });
    });
  }

  @override
  void dispose() {
    try {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      timer.cancel();
      super.dispose();
    } catch (e) {
      timer.cancel();
      super.dispose();
    }
  }

  void updateDrivePoints() {
    final currentUser = ref.read(currentUserStateProvider);
    if (currentUser == null) return;

    final lastSession = ref.read(sessionNotifierProvider);
    final totalPoints = currentUser.drivePoints + lastSession.points;
    ref
        .read(updateUserDrivePointsControllerProvider.notifier)
        .updateUserDrivePoints(totalPoints);
  }

  Future<void> startDrive(User? currentUser, int lastDrivePoints) async {
    if (state == 'Stopped') {
      if (currentUser == null) {
        return;
      }

      // Reset lastSession when starting a new session
      ref.read(sessionNotifierProvider.notifier).updateSession(
            Session(
                points: 0,
                timeElapsed: Duration.zero,
                getAchievement: true,
                userGoal: currentUser.userGoal,
                goalCompleteByTime: currentUser.goalCompleteByTime,
                sessionBadges: []),
          );

      setState(() {
        state = 'Started';
        buttonSize = 20;
      });

      await simulateDelay(15);

      if (await updateElapsedEarnings() == "Kiosk Mode not enabled") {
        _showSnackBar(
            "Kiosk Mode Error. Kiosk mode must be functioning to start a session. If Kiosk mode was enabled and you are seeing this message, click 'Start Focus' to unpin and try again.");
        setState(() {
          state = 'Stopped';
          buttonSize = 100;
          buttonText = 'Start';
        });
        return;
      } else if (await updateElapsedEarnings() == '') {
        setState(() {
          pauseButtonText = 'Pause';
          titleText = 'This';
          buttonText = 'End';
          state = 'Started';
          buttonSize = 20;
        });

        stopWatch.start();
      }
    } else {
      // Persist drive when stopping and stop kiosk mode
      stopWatch.stop();

      setState(() {
        titleText = 'Last';
        buttonText = 'Start';
        state = 'Stopped';
        buttonSize = 100;
      });

      if (currentUser != null) {
        ref.read(
          updateUserLeagueStatusControllerProvider(
            currentUser,
            lastDrivePoints,
          ),
        );

        //Update streak, streak achievements, and daily goal
        ref.read(UpdateDailyGoalControllerProvider(
            currentUser.userGoal, stopWatch.elapsed.inSeconds));

        //Update time elapsed in minutes (for achievements)
        ref
            .read(updateUserEnduranceMinutesControllerProvider.notifier)
            .updateUser(currentUser.id,
                (stopWatch.elapsed.inSeconds + currentUser.enduranceSeconds));

        //Update streak achievements
        ref
            .read(updateDriveStreakBadgeControllerProvider.notifier)
            .updateUserDriveStreakBadge(currentUser);
      }
      stopWatch.reset();

      // Update drive points
      updateDrivePoints();

      //Navigate to achievements screen
      context.go('/home/achievements');
    }
  }

  Future<void> pauseDrive() async {
    if (state == 'Started' && pauseButtonText == "Pause") {
      setState(() {
        pauseButtonText = 'Resume';
      });
      stopWatch.stop();
      await simulateDelay(5);
    } else {
      await simulateDelay(15);

      if (await updateElapsedEarnings() == "Kiosk Mode not enabled") {
        _showSnackBar(
            "Kiosk Mode Error. Kiosk mode must be functioning to resume your session. If Kiosk mode was enabled and you are seeing this message, click 'Resume Focus' to unpin and try again.");
        return;
      } else if (await updateElapsedEarnings() == '') {
        setState(() {
          pauseButtonText = 'Pause';
        });
        stopWatch.start();
      }
    }
  }

  Future<String> updateElapsedEarnings() async {
    final mode = await getKioskMode();
    final thisSession = ref.read(sessionNotifierProvider);
    final currentUser = ref.read(currentUserStateProvider);

    if (state == "Started" && mode == KioskMode.disabled) {
      stopWatch.stop();
      if (pauseButtonText != "Resume") {
        pauseButtonText = "Resume";
        ref.read(bottomNavBarVisibilityProvider.notifier).state =
            !ref.read(bottomNavBarVisibilityProvider);
        // _showSnackBar(
        //     "Oops! It looks like Kiosk mode was disabled. Press 'Resume Focus' and re-enable Kiosk Mode to continue your session.");
      }
      return "Kiosk Mode not enabled";
    }

    if (currentUser == null) {
      return '';
    }

    final updatedSession = thisSession.copyWith(
      timeElapsed: stopWatch.elapsed.inSeconds < currentUser.userGoal
          ? Duration(seconds: currentUser.userGoal) -
              stopWatch.elapsed // Countdown
          : stopWatch.elapsed -
              Duration(seconds: currentUser.userGoal), // Count Up
      points: (stopWatch.elapsed.inMinutes >=
              lastAwardedMinute + Numbers.pointsAwardIntervalMinutes)
          ? thisSession.points + 1
          : thisSession.points,
    );

    if (updatedSession.points > thisSession.points) {
      lastAwardedMinute = stopWatch.elapsed.inMinutes;
    }

    ref.read(sessionNotifierProvider.notifier).updateSession(updatedSession);
    return '';
  }

  void _showSnackBar(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 30),
          action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () {
                try {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                } catch (e) {
                  null;
                }
              }),
          dismissDirection: DismissDirection.down,
          content: Text(
            message,
            style: TextStyles.semiFinePrint,
          ),
        ),
      );

  void _handleStart(bool didStart) {
    if (!didStart && Platform.isIOS) {
      _showSnackBar(_unsupportedMessage);
    }
  }

  void _handleStop(bool? didStop) {
    if (didStop == false) {
      _showSnackBar(
        'Kiosk mode could not be stopped or was not active to begin with.',
      );
    }
  }

  String formatGoalTime(int userGoal) {
    if (userGoal < 0) {
      userGoal = userGoal * -1;
    }

    final userGoalMinutes = (userGoal / 60).floor().toInt();

    if (userGoal == 0) {
      return '--:--';
    } else {
      return '${userGoalMinutes}m ${userGoal.remainder(60)}s';
    }
  }

  Future<void> simulateDelay(int seconds) async {
    setState(() {
      state = "Loading";
    }); // Show loading
    await Future.delayed(Duration(seconds: seconds)); // Simulate delay
    setState(() {
      state = "Started";
    }); // Hide loading
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: _currentMode,
      builder: (context, snapshot) {
        final mode = snapshot.data;
        final thisSession = ref.watch(sessionNotifierProvider);
        final currentUser = ref.watch(currentUserStateProvider);
        ref.watch(updateUserDriveStreakControllerProvider);
        ref.watch(updateUserLastDriveStreakAtControllerProvider);
        ref.watch(updateUserDrivePointsControllerProvider);
        ref.watch(updateUserEnduranceMinutesControllerProvider);
        ref.watch(updateDriveStreakBadgeControllerProvider);

        if (currentUser == null) return Container();

        return Stack(
          children: [
            const CheckeredFlag(),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 75)),
                  Text(
                    state == 'Stopped' && currentUser.userGoal < 0
                        ? 'Focus Goal: +${formatGoalTime(currentUser.userGoal)}'
                        : state == 'Stopped' && currentUser.userGoal >= 0
                            ? 'Focus Goal: ${formatGoalTime(currentUser.userGoal)}'
                            : state == 'Started' &&
                                    stopWatch.elapsed.inSeconds <
                                        currentUser.userGoal
                                ? 'Focus Goal: ${thisSession.timeElapsed.inMinutes}m ${thisSession.timeElapsed.inSeconds.remainder(60)}s'
                                : state == 'Started' &&
                                        stopWatch.elapsed.inSeconds >=
                                            currentUser.userGoal
                                    ? 'Focus Goal: +${thisSession.timeElapsed.inMinutes}m ${thisSession.timeElapsed.inSeconds.remainder(60)}s'
                                    : '',
                    textAlign: TextAlign.center,
                    style: TextStyles.h3,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  Text(
                    'Current Session Time: ${stopWatch.elapsed.inMinutes}m ${stopWatch.elapsed.inSeconds.remainder(60)}s',
                    textAlign: TextAlign.center,
                    style: TextStyles.bodySmall,
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 15)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (thisSession.points > 99)
                        _buildPointContainer(
                            (thisSession.points ~/ 100).toString()),
                      _buildPointContainer(
                          ((thisSession.points ~/ 10) % 10).toString()),
                      _buildPointContainer(
                          ((thisSession.points ~/ 1) % 10).toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentUser.userGoal != 0) ...{
                        if (state == 'Started')
                          Padding(
                            padding: const EdgeInsets.only(top: 40, right: 10),
                            child: Center(
                              child: CustomButton(
                                text: '$pauseButtonText Focus',
                                onPressed: () {
                                  if (state == "Started" &&
                                      pauseButtonText == "Pause") {
                                    switch (mode) {
                                      case null:
                                      case KioskMode.disabled:
                                        return; // Do nothing
                                      case KioskMode.enabled:
                                        pauseDrive();
                                        stopKioskMode().then(_handleStop);
                                        ref
                                                .read(
                                                    bottomNavBarVisibilityProvider
                                                        .notifier)
                                                .state =
                                            !ref.read(
                                                bottomNavBarVisibilityProvider);
                                        break;
                                    }
                                  } else if (state == "Started" &&
                                      pauseButtonText == "Resume") {
                                    switch (mode) {
                                      case null:
                                      case KioskMode.enabled:
                                        stopKioskMode().then(_handleStop);
                                      case KioskMode.disabled:
                                        startKioskMode().then(_handleStart);
                                        pauseDrive();
                                        ref
                                                .read(
                                                    bottomNavBarVisibilityProvider
                                                        .notifier)
                                                .state =
                                            !ref.read(
                                                bottomNavBarVisibilityProvider);
                                        break;
                                    }
                                  }
                                },
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
                              text: '$buttonText Focus',
                              onPressed: () {
                                if (state == "Stopped") {
                                  switch (mode) {
                                    case null:
                                    case KioskMode.enabled:
                                      stopKioskMode().then(_handleStop);
                                      ref
                                              .read(
                                                  bottomNavBarVisibilityProvider
                                                      .notifier)
                                              .state =
                                          !ref.read(
                                              bottomNavBarVisibilityProvider);
                                      break;
                                    case KioskMode.disabled:
                                      startKioskMode().then(_handleStart);
                                      startDrive(
                                          currentUser, thisSession.points);
                                      ref
                                              .read(
                                                  bottomNavBarVisibilityProvider
                                                      .notifier)
                                              .state =
                                          !ref.read(
                                              bottomNavBarVisibilityProvider);
                                      break;
                                  }
                                } else if (state == "Started") {
                                  switch (mode) {
                                    case null:
                                    case KioskMode.disabled:
                                      if (buttonText != "End") {
                                        state = "Stopped";
                                        _showSnackBar(
                                            "You must have Kiosk Mode enabled while your Focus Session is active in order for the session to be valid. Sorry, try again!");
                                        return;
                                      } else {
                                        startDrive(
                                            currentUser, thisSession.points);
                                      }
                                    case KioskMode.enabled:
                                      stopKioskMode().then(_handleStop);
                                      ref
                                              .read(
                                                  bottomNavBarVisibilityProvider
                                                      .notifier)
                                              .state =
                                          !ref.read(
                                              bottomNavBarVisibilityProvider);
                                      startDrive(
                                          currentUser, thisSession.points);
                                      break;
                                  }
                                } else if (state == "Paused") {
                                  startDrive(currentUser, thisSession.points);
                                }
                              },
                              horizontalPadding: buttonSize,
                              backgroundColor: AppColors.customPink,
                            ),
                          ),
                        ),
                      } else ...{
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: CustomButton(
                              text: 'Set Daily Goal',
                              onPressed: () => context.go('/home/setGoal'),
                              backgroundColor: AppColors.customPink,
                            ),
                          ),
                        ),
                      },
                    ],
                  ),
                ],
              ),
            ),

            // Loading overlay
            if (state == "Loading")
              Positioned.fill(
                child: Container(
                  color: const Color.fromARGB(150, 168, 168, 168),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        );
      });

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

const _unsupportedMessage = '''
Single App mode is supported only for devices that are supervised 
using Mobile Device Management (MDM) and the app itself must 
be enabled for this mode by MDM.
''';
