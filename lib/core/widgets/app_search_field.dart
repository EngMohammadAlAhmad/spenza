import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';

class AppSearchField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppSearchField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
  }

  @override
  void didUpdateWidget(covariant AppSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller && widget.controller != null) {
      _internalController = widget.controller!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  TextEditingController get _effectiveController => widget.controller ?? _internalController;

  void _triggerSearch() {
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(_effectiveController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _effectiveController,
      fillColor: AppColors.neutral200,
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      onSubmitted: widget.onSubmitted,
      prefixIcon: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _triggerSearch,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 16.0, end: 8.0),
          child: SvgPicture.asset(
            AppAssets.searchIcon,
            colorFilter: const ColorFilter.mode(AppColors.neutral, BlendMode.srcIn),
          ),
        ),
      ),
      suffixIcon: widget.onSubmitted != null
          ? IconButton(
              icon: const Icon(Icons.search, color: AppColors.neutral),
              onPressed: _triggerSearch,
            )
          : null,
      hintText: widget.hintText ?? 'search_placeholder'.tr(),
      onChanged: widget.onChanged,
      horizontalContentPadding: 16.0,
      verticalContentPadding: 12.0,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
    );
  }
}
