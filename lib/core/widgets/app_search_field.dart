import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';

class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppSearchField({
    super.key,
    this.controller,
    this.hintText = 'ابحث عن قلم، دفتر، حقيبة...',
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller ?? TextEditingController(),
      fillColor: AppColors.neutral200,
      focusNode: focusNode,
      readOnly: readOnly,
      onTap: onTap,
      onSubmitted: onSubmitted,
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16.0, end: 8.0),
        child: SvgPicture.asset(
          'assets/icons/search_icon.svg',
          colorFilter: const ColorFilter.mode(AppColors.neutral, BlendMode.srcIn),
        ),
      ),
      suffixIcon: onSubmitted != null
          ? IconButton(
              icon: const Icon(Icons.search, color: AppColors.neutral),
              onPressed: () {
                onSubmitted!((controller ?? TextEditingController()).text);
              },
            )
          : null,
      hintText: hintText,
      onChanged: onChanged,
      horizontalContentPadding: 16.0,
      verticalContentPadding: 12.0,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
    );
  }
}
