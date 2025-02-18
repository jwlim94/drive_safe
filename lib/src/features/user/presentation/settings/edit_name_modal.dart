import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/utils/input_format_utils.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:drive_safe/src/shared/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class EditNameModal extends StatefulWidget {
  const EditNameModal({
    super.key,
    required this.onSave,
  });

  final ValueChanged<String> onSave;

  @override
  State<EditNameModal> createState() => _EditNameModalState();
}

class _EditNameModalState extends State<EditNameModal> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChange(String value) {
    setState(() {
      _isButtonEnabled = value.trim().isNotEmpty;
    });
  }

  void _handleSave() {
    if (_isButtonEnabled) {
      widget.onSave(_controller.text.trim());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        right: 32,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        left: 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Edit Name',
            style: TextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.customBlack,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _controller,
            keyboardType: TextInputType.text,
            inputFormatters: InputFormatUtils.nameInputFormat,
            hintText: 'Enter new name',
            onChanged: _handleChange,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Save',
            backgroundColor: AppColors.customPink,
            onPressed: _isButtonEnabled ? _handleSave : null,
          ),
        ],
      ),
    );
  }
}
