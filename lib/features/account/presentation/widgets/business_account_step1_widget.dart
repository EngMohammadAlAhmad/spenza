import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';

class BusinessAccountStep1Widget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController entityNameController;
  final TextEditingController storeNameController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final String selectedActivity;
  final String selectedMonthlyEstimate;
  final VoidCallback? onActivityTap;
  final VoidCallback? onMonthlyEstimateTap;

  const BusinessAccountStep1Widget({
    super.key,
    required this.formKey,
    required this.entityNameController,
    required this.storeNameController,
    required this.addressController,
    required this.phoneController,
    required this.selectedActivity,
    required this.selectedMonthlyEstimate,
    this.onActivityTap,
    this.onMonthlyEstimateTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTabletLandscape = context.isTabletLandscape;

    final column1 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextFieldSection(
          context: context,
          label: 'entity_name'.tr(),
          controller: entityNameController,
          hintText: 'enter_entity_name'.tr(),
        ),
        const SizedBox(height: 16.0),
        _buildTextFieldSection(
          context: context,
          label: 'store_name'.tr(),
          controller: storeNameController,
          hintText: 'enter_store_name'.tr(),
        ),
        const SizedBox(height: 16.0),
        _buildDropdownField(
          context: context,
          label: 'activity_type'.tr(),
          value: selectedActivity,
          hintText: 'select_activity'.tr(),
          onTap: onActivityTap,
        ),
      ],
    );

    final column2 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextFieldSection(
          context: context,
          label: 'address'.tr(),
          controller: addressController,
          hintText: 'enter_detailed_address'.tr(),
        ),
        const SizedBox(height: 16.0),
        _buildPhoneFieldSection(context),
        const SizedBox(height: 16.0),
        _buildDropdownField(
          context: context,
          label: 'monthly_purchase_estimate_optional'.tr(),
          value: selectedMonthlyEstimate,
          hintText: 'select_range'.tr(),
          onTap: onMonthlyEstimateTap,
        ),
      ],
    );

    final formContent = isTabletLandscape
        ? Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Physical LEFT side
                Expanded(
                  child: Directionality(
                    textDirection: Directionality.of(context),
                    child: column2,
                  ),
                ),
                const SizedBox(width: 20.0),
                // Physical RIGHT side
                Expanded(
                  child: Directionality(
                    textDirection: Directionality.of(context),
                    child: column1,
                  ),
                ),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              column1,
              const SizedBox(height: 16.0),
              column2,
            ],
          );

    return Form(
      key: formKey,
      child: formContent,
    );
  }

  Widget _buildTextFieldSection({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required String hintText,
    String? helperText,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8.0),
        CustomTextField(
          controller: controller,
          hintText: hintText,
          keyboardType: keyboardType,
          fillColor: Colors.white,
          borderColor: AppColors.neutralBorderDefault,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral900,
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6.0),
          Text(
            helperText,
            style: const TextStyle(
              fontSize: 12.0,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPhoneFieldSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'contact_phone_number'.tr(),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8.0),
        Directionality(
          textDirection: TextDirection.ltr,
          child: CustomTextField(
            controller: phoneController,
            hintText: '9xx xxx xxx',
            forPhone: true,
            fillColor: Colors.white,
            borderColor: AppColors.neutralBorderStrong,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _PhoneInputFormatter(),
            ],
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'phone_validation'.tr();
              }
              final clean = val.replaceAll(' ', '');
              if (!clean.startsWith('9') || clean.length != 9) {
                return 'valid_phone_error'.tr();
              }
              return null;
            },
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 14.0),
                SvgPicture.asset(AppAssets.syFlag, width: 22),
                const SizedBox(width: 6.0),
                Text(
                  '+963',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.neutral700,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  width: 25.0,
                  height: 24.0,
                  child: VerticalDivider(
                    color: AppColors.primaryLight.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Text(
          'contact_phone_note'.tr(),
          style: const TextStyle(
            fontSize: 12.0,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required String value,
    required String hintText,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8.0),
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            onTap?.call();
          },
          borderRadius: AppRadius.brandRadius,
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.brandRadius,
              border: Border.all(color: AppColors.neutralBorderDefault),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.neutral700,
                  size: 22.0,
                ),
                Expanded(
                  child: Text(
                    value.isNotEmpty ? value : hintText,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: value.isNotEmpty
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: value.isNotEmpty
                          ? AppColors.neutral900
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 9) return oldValue;

    var newText = '';
    for (var i = 0; i < text.length; i++) {
      newText += text[i];
      if ((i == 2 || i == 5) && i != text.length - 1) {
        newText += ' ';
      }
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
