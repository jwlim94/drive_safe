import 'package:drive_safe/src/features/home/presentation/controllers/update_daily_goal_controller.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/checkered_flag.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalSetScreen extends ConsumerStatefulWidget {
  const GoalSetScreen({super.key});

  @override
  ConsumerState<GoalSetScreen> createState() => _GoalSetScreenState();
}

class _GoalSetScreenState extends ConsumerState<GoalSetScreen> {
  @override
  void initState() {
    super.initState();
  }

  void setDailyGoal(int dailyGoal) {
    ref.read(updateDailyGoalControllerProvider(dailyGoal));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CheckeredFlag(),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(
                color: AppColors.customLightPurple, size: 55),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.only(top: 50)),
                const Text(
                  'AutoFocus Time',
                  textAlign: TextAlign.center,
                  style: TextStyles.h2,
                ),
                const Text(
                  'Select a time to set a goal',
                  textAlign: TextAlign.center,
                  style: TextStyles.bodySmall,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                ),
                const Text(
                  'Newbie',
                  textAlign: TextAlign.center,
                  style: TextStyles.bodyMedium,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: '5m',
                      onPressed: () => setDailyGoal(5),
                      backgroundColor: AppColors.customPink,
                      horizontalPadding: 28,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18),
                    ),
                    CustomButton(
                      text: '10m',
                      onPressed: () => setDailyGoal(10),
                      backgroundColor: AppColors.customPink,
                      horizontalPadding: 23,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18),
                    ),
                    CustomButton(
                      text: '15m',
                      onPressed: () => setDailyGoal(15),
                      backgroundColor: AppColors.customPink,
                      horizontalPadding: 23,
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                ),
                const Text(
                  'Rookie',
                  textAlign: TextAlign.center,
                  style: TextStyles.bodyMedium,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: '20m',
                      onPressed: () => setDailyGoal(20),
                      backgroundColor: AppColors.customPink,
                      horizontalPadding: 22,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18),
                    ),
                    CustomButton(
                      text: '25m',
                      onPressed: () => setDailyGoal(25),
                      backgroundColor: AppColors.customPink,
                      horizontalPadding: 22,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18),
                    ),
                    CustomButton(
                      text: '30m',
                      onPressed: () => setDailyGoal(30),
                      backgroundColor: AppColors.customPink,
                      horizontalPadding: 22,
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                ),
                const Text(
                  'Proficient',
                  textAlign: TextAlign.center,
                  style: TextStyles.bodyMedium,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: '35m',
                      onPressed: () => setDailyGoal(35),
                      backgroundColor: AppColors.customPink,
                      horizontalPadding: 22,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18),
                    ),
                    CustomButton(
                      text: '40m',
                      onPressed: () => setDailyGoal(40),
                      backgroundColor: AppColors.customPink,
                      horizontalPadding: 22,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18),
                    ),
                    CustomButton(
                      text: '45m',
                      onPressed: () => setDailyGoal(45),
                      backgroundColor: AppColors.customPink,
                      horizontalPadding: 22,
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                ),
                const Text(
                  'Legend',
                  textAlign: TextAlign.center,
                  style: TextStyles.bodyMedium,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: '50m',
                      onPressed: () => setDailyGoal(50),
                      backgroundColor: AppColors.customPink,
                      horizontalPadding: 22,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18),
                    ),
                    CustomButton(
                      text: '55m',
                      onPressed: () => setDailyGoal(55),
                      backgroundColor: AppColors.customPink,
                      horizontalPadding: 22,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18),
                    ),
                    CustomButton(
                      text: '60m',
                      onPressed: () => setDailyGoal(60),
                      backgroundColor: AppColors.customPink,
                      horizontalPadding: 22,
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                ),
                const Text(
                  'Grandmaster',
                  textAlign: TextAlign.center,
                  style: TextStyles.bodyMedium,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: '1.5h',
                      onPressed: () => setDailyGoal(90),
                      backgroundColor: AppColors.customPink,
                      horizontalPadding: 23,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18),
                    ),
                    CustomButton(
                      text: '3h',
                      onPressed: () => setDailyGoal(180),
                      backgroundColor: AppColors.customPink,
                      horizontalPadding: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18),
                    ),
                    CustomButton(
                      text: '6h',
                      onPressed: () => setDailyGoal(360),
                      backgroundColor: AppColors.customPink,
                      horizontalPadding: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
