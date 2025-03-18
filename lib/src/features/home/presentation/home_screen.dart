import 'dart:io';

import 'package:drive_safe/src/features/home/domain/drive.dart';
import 'package:drive_safe/src/features/home/presentation/providers/last_drive_provider.dart';
import 'package:drive_safe/src/features/leaderboard/presentation/controllers/update_user_league_status_controller.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_drive_points_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_drive_streak_controller.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_last_drive_streak_at_controller.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
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

  void updateDriveStreak() {
    final currentUser = ref.read(currentUserStateProvider);
    if (currentUser == null) return;

    final lastDriveStreakAt = currentUser.lastDriveStreakAt;

    // First time streak tracking.
    if (lastDriveStreakAt == null) {
      ref
          .read(updateUserDriveStreakControllerProvider.notifier)
          .updateUserDriveStreak();
      ref
          .read(updateUserLastDriveStreakAtControllerProvider.notifier)
          .updateUserLastDriveStreakAt();
    }

    final currentDate = DateTime.now();
    final currentTimestamp =
        DateTime(currentDate.year, currentDate.month, currentDate.day)
            .millisecondsSinceEpoch;

    final lastStreakDate =
        DateTime.fromMillisecondsSinceEpoch(lastDriveStreakAt!);
    final lastTimestamp =
        DateTime(lastStreakDate.year, lastStreakDate.month, lastStreakDate.day)
            .millisecondsSinceEpoch;

    if (currentTimestamp == lastTimestamp) return;

    // Update when it is not on the same day.
    ref
        .read(updateUserDriveStreakControllerProvider.notifier)
        .updateUserDriveStreak();
    ref
        .read(updateUserLastDriveStreakAtControllerProvider.notifier)
        .updateUserLastDriveStreakAt();
  }

  void updateDrivePoints() {
    final currentUser = ref.read(currentUserStateProvider);
    if (currentUser == null) return;

    final lastDrive = ref.read(lastDriveNotifierProvider);
    final totalPoints = currentUser.drivePoints + lastDrive.points;
    ref
        .read(updateUserDrivePointsControllerProvider.notifier)
        .updateUserDrivePoints(totalPoints);
  }

  Future<void> startDrive(User? currentUser, int lastDrivePoints) async {
    if (state == 'Stopped') {
      // Reset lastDrive when starting a new drive
      ref.read(lastDriveNotifierProvider.notifier).addLastDrive(
            Drive(points: 0, timeElapsed: Duration.zero, getAchievement: true),
          );

      setState(() {
        state = 'Started';
        buttonSize = 20;
      });

      await simulateDelay();

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
      stopWatch.reset();

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
      }

      // Update drive streak and last drive streak date
      updateDriveStreak();

      // Update drive points
      updateDrivePoints();

      // Navigate if achievement is earned
      final lastDrive = ref.read(lastDriveNotifierProvider);
      if (lastDrive.getAchievement) {
        context.go('/home/achievements');
      }
    }
  }

  Future<void> pauseDrive() async {
    if (state == 'Started' && pauseButtonText == "Pause") {
      setState(() {
        pauseButtonText = 'Resume';
      });
      stopWatch.stop();
    } else {
      await simulateDelay();

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
    final lastDrive = ref.read(lastDriveNotifierProvider);
    final currentUser = ref.read(currentUserStateProvider);

    if (state == "Started" && mode == KioskMode.disabled) {
      stopWatch.stop();
      if (pauseButtonText != "Resume") {
        pauseButtonText = "Resume";
        _showSnackBar(
            "Oops! It looks like Kiosk mode was disabled. Press 'Resume Focus' and re-enable Kiosk Mode to continue your session.");
      }
      return "Kiosk Mode not enabled";
    }

    if (currentUser == null) {
      return '';
    }

    final updatedDrive = lastDrive.copyWith(
      timeElapsed: stopWatch.elapsed.inSeconds < currentUser.userGoal * 60
          ? Duration(seconds: currentUser.userGoal * 60) -
              stopWatch.elapsed // Countdown
          : stopWatch.elapsed -
              Duration(seconds: currentUser.userGoal * 60), // Count Up
      points: (stopWatch.elapsed.inMinutes >=
              lastAwardedMinute + Numbers.pointsAwardIntervalMinutes)
          ? lastDrive.points + 1
          : lastDrive.points,
    );

    if (updatedDrive.points > lastDrive.points) {
      lastAwardedMinute = stopWatch.elapsed.inMinutes;
    }

    ref.read(lastDriveNotifierProvider.notifier).addLastDrive(updatedDrive);
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
    if (userGoal == 0) {
      return '--:--';
    } else {
      int minutes = userGoal;
      return '${minutes}m 0s';
    }
  }

  Future<void> simulateDelay() async {
    setState(() {
      state = "Loading";
    }); // Show loading
    await Future.delayed(const Duration(seconds: 15)); // Simulate delay
    setState(() {
      state = "Started";
    }); // Hide loading
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: _currentMode,
      builder: (context, snapshot) {
        final mode = snapshot.data;
        final lastDrive = ref.watch(lastDriveNotifierProvider);
        final currentUser = ref.watch(currentUserStateProvider);
        ref.watch(updateUserDriveStreakControllerProvider);
        ref.watch(updateUserLastDriveStreakAtControllerProvider);
        ref.watch(updateUserDrivePointsControllerProvider);

        // TODO: handle loading state
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Text(
                      state == 'Stopped'
                          ? 'Focus Goal: ${formatGoalTime(currentUser.userGoal)}'
                          : 'Focus Goal: ${lastDrive.timeElapsed.inMinutes}m ${lastDrive.timeElapsed.inSeconds.remainder(60)}s',
                      textAlign: TextAlign.center,
                      style: TextStyles.h3,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (lastDrive.points > 99)
                        _buildPointContainer(
                            (lastDrive.points ~/ 100).toString()),
                      _buildPointContainer(
                          ((lastDrive.points ~/ 10) % 10).toString()),
                      _buildPointContainer(
                          ((lastDrive.points ~/ 1) % 10).toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentUser.userGoal > 0) ...{
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
                                      break;
                                    case KioskMode.disabled:
                                      startKioskMode().then(_handleStart);
                                      startDrive(currentUser, lastDrive.points);
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
                                            currentUser, lastDrive.points);
                                      }
                                    case KioskMode.enabled:
                                      stopKioskMode().then(_handleStop);
                                      startDrive(currentUser, lastDrive.points);
                                      break;
                                  }
                                } else if (state == "Paused") {
                                  startDrive(currentUser, lastDrive.points);
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
