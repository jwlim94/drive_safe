import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/routing/utils/custom_app_bar.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreenBasicInfo extends StatefulWidget {
  const OnboardingScreenBasicInfo({super.key});

  @override
  State<OnboardingScreenBasicInfo> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreenBasicInfo> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.customBlack,
      appBar: CustomAppBar(
          selectedIndex: selectedIndex, onItemTapped: onItemTapped),
      body: ListView(
        children: [_userInputFields()],
      ),
    );
  }

  Column _userInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, left: 20, bottom: 40),
          child: const Text(
            'Basic\nInformation',
            style: TextStyles.h2,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 7.0, left: 20),
          child: Text(
            'What should we call you, rider?',
            textAlign: TextAlign.start,
            style: TextStyles.searchHeader,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 40,
                spreadRadius: 0.0)
          ]),
          child: TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.customWhite, width: 1.0)),
                contentPadding: const EdgeInsets.all(15),
                hintText: 'Enter Name',
                hintStyle: TextStyles.searchHint,
                suffixIcon: const SizedBox(
                  width: 100,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none)),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 7.0, left: 20),
          child: Text(
            'How old are you?',
            textAlign: TextAlign.start,
            style: TextStyles.searchHeader,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 40,
                spreadRadius: 0.0)
          ]),
          child: TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.customWhite, width: 1.0)),
                contentPadding: const EdgeInsets.all(15),
                hintText: 'Enter Age',
                hintStyle: TextStyles.searchHint,
                suffixIcon: const SizedBox(
                  width: 100,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: CustomButton(
              text: "Continue",
              onPressed: () => context.go('/onboardingVehicleSelection'),
              horizontalPadding: 115,
              backgroundColor: AppColors.customPink,
            ),
          ),
        ),
      ],
    );
  }
}
