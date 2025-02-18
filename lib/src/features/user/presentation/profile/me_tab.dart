import 'package:drive_safe/src/features/car/presentation/providers/current_car_state_provider.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeTab extends ConsumerWidget {
  const MeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserStateProvider);
    final currentCar = ref.watch(currentCarStateProvider);

    // TODO: Handle error state
    if (currentUser == null) return Container();
    if (currentCar == null) return Container();

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: ColorUtils.toColor(currentUser.primaryColor),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  currentUser.name[0].toUpperCase(),
                  style: TextStyle(
                    color: ColorUtils.toColor(currentUser.secondaryColor),
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUser.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.customWhite,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${currentCar.description} ${currentCar.type}",
                    style: const TextStyle(
                      fontSize: 24,
                      color: AppColors.customWhite,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
