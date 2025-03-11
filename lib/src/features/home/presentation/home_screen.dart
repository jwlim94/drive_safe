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
    timer.cancel();
    super.dispose();
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

  Future<bool> isInKioskMode() async {
    final mode = await getKioskMode();
    if (mode == KioskMode.enabled) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _waitForKioskModeActivation() async {
    for (int i = 0; i < 1000000; i++) {
      // Wait up to 10 seconds
      await Future.delayed(const Duration(seconds: 1));
      if (await isInKioskMode()) {
        return true; // User accepted Kiosk Mode
      }
    }
    return false; // User rejected or timeout reached
  }

  void _showKioskModeInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kiosk Mode Required'),
          content: const Text(
              'You will be unable to start the focus session without Kiosk Mode enabled. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> startDrive(User? currentUser, int lastDrivePoints) async {
    if (state == 'Stopped') {
      await startKioskMode();

      // Wait a few seconds to check if Kiosk Mode was activated
      bool isKioskActive = await _waitForKioskModeActivation();

      if (!isKioskActive) {
        debugPrint("User rejected Kiosk Mode. Drive session will not start.");
        _showKioskModeInfoDialog();
        return; // Exit if user denied Kiosk Mode
      }

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
      // Persist drive when stopping and stop kiosk mode
      stopKioskMode();
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
        context.go('/achievements');
      }
    }
  }

  void pauseDrive() async {
    if (pauseButtonText == 'Pause') {
      setState(() {
        pauseButtonText = 'Resume';
      });
      stopKioskMode();
      stopWatch.stop();
    } else {
      await startKioskMode();

      // Wait a few seconds to check if Kiosk Mode was activated
      bool isKioskActive = await _waitForKioskModeActivation();

      if (!isKioskActive) {
        debugPrint("User rejected Kiosk Mode. Drive session will not start.");
        _showKioskModeInfoDialog();
        return; // Exit if user denied Kiosk Mode
      }

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
      points: (stopWatch.elapsed.inMinutes >=
              lastAwardedMinute + Numbers.pointsAwardIntervalMinutes)
          ? lastDrive.points + 1
          : lastDrive.points,
    );

    if (updatedDrive.points > lastDrive.points) {
      lastAwardedMinute = updatedDrive.timeElapsed.inMinutes;
    }

    ref.read(lastDriveNotifierProvider.notifier).addLastDrive(updatedDrive);
  }

  @override
  Widget build(BuildContext context) {
    final lastDrive = ref.watch(lastDriveNotifierProvider);
    final currentUser = ref.watch(currentUserStateProvider);
    ref.watch(updateUserDriveStreakControllerProvider);
    ref.watch(updateUserLastDriveStreakAtControllerProvider);
    ref.watch(updateUserDrivePointsControllerProvider);

    // TODO: handle loading state
    if (currentUser == null) return Container();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              'Points $titleText Session',
              textAlign: TextAlign.center,
              style: TextStyles.h2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (lastDrive.points > 99)
                _buildPointContainer((lastDrive.points ~/ 100).toString()),
              _buildPointContainer(((lastDrive.points ~/ 10) % 10).toString()),
              _buildPointContainer(((lastDrive.points ~/ 1) % 10).toString()),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              'Focus Session Minutes: ${lastDrive.timeElapsed.inMinutes}m ${lastDrive.timeElapsed.inSeconds.remainder(60)}s',
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
                    text: '$pauseButtonText Focus',
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
                  text: '$buttonText Focus',
                  onPressed: () => startDrive(currentUser, lastDrive.points),
                  horizontalPadding: buttonSize,
                  backgroundColor: AppColors.customPink,
                ),
              ),
            ),
          ])
        ],
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
