import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_images.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';

class SignupStep2 extends StatefulWidget {
  final Function(String) onNext;

  const SignupStep2({super.key, required this.onNext});

  @override
  State<SignupStep2> createState() => _SignupStep2State();
}

class _SignupStep2State extends State<SignupStep2> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(24.0, 60.0, 24.0, 10.0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            '2/3',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.primary,
              fontWeight: .bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'رقم موبايلك',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.primary,
              fontWeight: .w700,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            'سجّل رقمك لنبعتلك عليه رمز التحقق',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.neutral,
            ),
          ),
          const SizedBox(height: 32.0),

          Text(
            'رقم موبايلك',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: .bold,
              color: Colors.black,
              fontSize: 13.0,
            ),          ),
          const SizedBox(height: 12.0),

          _buildPhoneField(),

          const Spacer(),

          CustomButton(
            text: 'ابعتلي رمز التحقق',
            height: 56.0,
            onPressed: _isPhoneValid
                ? () => widget.onNext(_phoneController.text.replaceAll(' ', ''))
                : null,
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  bool get _isPhoneValid {
    final clean = _phoneController.text.replaceAll(' ', '');
    return clean.startsWith('9') && clean.length == 9;
  }

  Widget _buildPhoneField() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: CustomTextField(
        controller: _phoneController,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: AppColors.neutral,
        ),
        onChanged: (_) => setState(() {}),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          _PhoneInputFormatter(),
        ],
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 20.0),
            SvgPicture.asset(AppAssets.syFlag, width: 24),
            const SizedBox(width: 8.0),
            Text(
              '+963',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.neutral700,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 25.0,
              height: 52.0,
              child: VerticalDivider(
                color: AppColors.primaryLight.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        textDirection: TextDirection.ltr,
        forPhone: true,
        borderColor: AppColors.primaryLight.withValues(alpha: 0.5),
        hintText: '9xx xxx xxx',
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: AppColors.neutral,
          fontFamily: 'Baloo2',
        ),
        fillColor: Colors.white,
      ),
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
