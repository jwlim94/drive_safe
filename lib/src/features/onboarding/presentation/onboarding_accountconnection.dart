import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/routing/utils/custom_app_bar.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingAccountconnection extends StatefulWidget {
  const OnboardingAccountconnection({super.key});

  @override
  State<OnboardingAccountconnection> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingAccountconnection> {
  int selectedIndex = 2;

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
            'Account\nConnection',
            style: TextStyles.h2,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 7.0, left: 20, right: 20),
          child: Text(
            'If you would like to backup your data, enter your email address.',
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
                hintText: 'Enter Email Address',
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
              text: "Finish",
              onPressed: () => context.go('/home'),
              horizontalPadding: 115,
              backgroundColor: AppColors.customPink,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20, left: 40, right: 40),
          child: Text(
            '*By selecting \'Finish\' you agree to allow Drive_Safe to collect your location data\n*You can always connect your email later by going to \'Settings\' -> \'Connect Account\'',
            textAlign: TextAlign.start,
            style: TextStyles.finePrint,
          ),
        ),
      ],
    );
  }
}
