import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';

class CustomPlayerCard extends StatelessWidget {
  final int position;
  final int points;
  final String playerName;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color leagueTierColor;
  final double verticalPadding;
  final double horizontalPadding;
  final double borderRadius;
  final Color borderOutline;
  final Icon icon;
  final Color playerColor;
  final String positionMovement;
  final Color playerInitialColor;

  const CustomPlayerCard({
    super.key,
    required this.position,
    this.points = 100,
    this.playerName = "Player Name",
    this.onPressed,
    this.backgroundColor = Colors.white,
    this.leagueTierColor = Colors.white,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.borderRadius = 15,
    this.borderOutline = Colors.white,
    this.icon = const Icon(Icons.remove),
    this.playerColor = AppColors.customBlack,
    this.positionMovement = "",
    this.playerInitialColor = AppColors.customBlack,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: position == 1
            ? BorderSide(
                color: borderOutline,
                width: 3,
              )
            : BorderSide.none,
      ),
      elevation: 3,
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: Row(
          children: [
            // Position Number
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                position.toString(),
                style: TextStyles.playerPositionPositionCardText,
              ),
            ),

            // Profile Icon Placeholder
            CircleAvatar(
              backgroundColor: playerColor, // Placeholder color
              radius: 19,
              child: Text(
                playerName[0],
                style: TextStyles.h3,
              ),
            ),

            // Player Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                playerName,
                style: TextStyles.playerNamePositionCardText,
              ),
            ),

            const Spacer(), // Pushes points and icon to the right

            Row(
              children: [
                positionMovement == "increased"
                    ? const Icon(Icons.arrow_upward_rounded,
                        color: AppColors.upArrow, size: 32)
                    : positionMovement == "decreased"
                        ? const Icon(Icons.arrow_downward_rounded,
                            color: AppColors.downArrow, size: 32)
                        : const Icon(Icons.remove,
                            color: AppColors.customBlack, size: 32)
              ],
            ),

            const SizedBox(width: 10),

            // Points
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: leagueTierColor),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  points.toString(),
                  style: TextStyles.h2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
