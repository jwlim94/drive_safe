import 'package:drive_safe/src/features/user/presentation/controllers/delete_user_controller.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DeleteAccountDialog extends ConsumerStatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends ConsumerState<DeleteAccountDialog> {
  void _handleDelete() {
    context.pop();
    ref.read(deleteUserControllerProvider.notifier).deleteUser();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Are you sure?",
        style: TextStyles.h4.copyWith(
          color: AppColors.customBlack,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "This action is irreversible. Your account and all associated data will be permanently deleted.",
        style: TextStyles.bodyMedium.copyWith(
          color: AppColors.customBlack,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _handleDelete,
          child: Text(
            "Delete",
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.customPink,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            "Cancel",
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.customDarkGray,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
