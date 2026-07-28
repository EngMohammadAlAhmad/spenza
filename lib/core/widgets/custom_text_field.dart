import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final TextStyle? labelStyle;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final Widget? suffixIcon;
  final int? maxLines;
  final TextDirection? textDirection;
  final bool enabled;
  final bool? forPrice;
  final bool? forPhone;
  final Color? fillColor;
  final Color? borderColor;
  final bool? allowTwoDecimalPlaces;
  final double? horizontalContentPadding;
  final double? verticalContentPadding;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    this.labelStyle,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.suffixIcon,
    this.maxLines = 1,
    this.textDirection,
    this.enabled = true,
    this.forPrice = false,
    this.forPhone = false,
    this.fillColor,
    this.borderColor,
    this.allowTwoDecimalPlaces,
    this.horizontalContentPadding = 16.0,
    this.verticalContentPadding = 16.0,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool shouldRestrictDecimals = forPrice == true || allowTwoDecimalPlaces == true;
    final bool shouldRestrictPhone = forPhone == true;

    // Determine the correct input formatters dynamically
    List<TextInputFormatter> formatters = [];
    if (shouldRestrictDecimals) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')));
    } else if (shouldRestrictPhone) {
      // Allows: 0-9, +, -, spaces, and parentheses ()
      // Blocks: letters, @, #, *, etc.
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'^[0-9+\-\s()]*$')));
    }

    Widget textField = TextFormField(
      controller: controller,
      validator: validator,
      // Automatically switch to the phone keyboard layout if forPhone is true
      keyboardType: shouldRestrictPhone ? (keyboardType ?? TextInputType.phone) : keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      textDirection: textDirection,
      enabled: enabled,
      onChanged: onChanged,
      inputFormatters: formatters,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        prefixIconConstraints: prefixIconConstraints ??
            const BoxConstraints(minWidth: 25.0, minHeight: 25.0),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor ?? AppColors.neutral200,
        border: OutlineInputBorder(
          borderRadius: AppRadius.extra4Large,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.extra4Large,
          borderSide: BorderSide(
            //color: borderColor ?? AppColors.borderColor.withValues(alpha: 0.2),
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.extra4Large,
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.extra4Large,
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.extra4Large,
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: horizontalContentPadding!,
          vertical: verticalContentPadding!,
        ),
      ),
    );

    if (label != null) {
      return Column(
        // Note: Fixed the syntax here from `.start` to `CrossAxisAlignment.start`
        crossAxisAlignment: CrossAxisAlignment.start,
        // Note: Fixed the syntax here from `.min` to `MainAxisSize.min`
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label!,
            style: labelStyle ?? Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8.0),
          textField,
        ],
      );
    }

    return textField;
  }
}