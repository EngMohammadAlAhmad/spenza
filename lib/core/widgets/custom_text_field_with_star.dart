import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

class CustomTextFieldWithStar extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextDirection textDirection;
  final int maxLines;
  final TextInputType keyboardType;
  final bool isRequired;

  // New optional parameters for form validation & customization
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final IconData? prefixIcon;
  final bool enabled;
  final Color? labelColor;
  final Color? starColor;
  final AutovalidateMode? autoValidateMode;

  const CustomTextFieldWithStar({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.textDirection = TextDirection.ltr,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    required this.isRequired,
    this.validator,
    this.inputFormatters,
    this.onChanged,
    this.onEditingComplete,
    this.focusNode,
    this.prefixIcon,
    this.enabled = true,
    this.labelColor,
    this.starColor,
    this.autoValidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w600,
                color: labelColor ?? Colors.black,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: starColor ?? Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          textDirection: textDirection,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          focusNode: focusNode,
          enabled: enabled,
          autovalidateMode: autoValidateMode,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: AppRadius.small,
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.small,
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.small,
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.small,
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.small,
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}