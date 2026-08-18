import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';

class LoginStep1 extends StatefulWidget {
  final Function(String) onNext;
  final VoidCallback onSignup;

  const LoginStep1({
    super.key,
    required this.onNext,
    required this.onSignup,
  });

  @override
  State<LoginStep1> createState() => _LoginStep1State();
}

class _LoginStep1State extends State<LoginStep1> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool get _isPhoneValid {
    final clean = _phoneController.text.replaceAll(' ', '');
    return clean.startsWith('9') && clean.length == 9;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    Text(
                      'يا هلا ومرحبا',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      'سجّل دخولك وخلي كل احتياجاتك أقرب مما تتخيل',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.neutral,
                          ),
                    ),
                    const SizedBox(height: 32.0),
                    Text(
                      'رقم موبايلك',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 13.0,
                          ),
                    ),
                    const SizedBox(height: 12.0),
                    _buildPhoneField(),
                    const SizedBox(height: 24.0),
                    CustomButton(
                      text: 'ابعتلي رمز التحقق',
                      height: 56.0,
                      onPressed: _isPhoneValid
                          ? () => widget.onNext(_phoneController.text.replaceAll(' ', ''))
                          : null,
                    ),
                    const SizedBox(height: 24.0),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'ما عندك حساب؟ ',
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: AppColors.neutral,
                                  ),
                            ),
                            TextSpan(
                              text: 'يلا نساوي حساب',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                              recognizer: TapGestureRecognizer()..onTap = widget.onSignup,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10.0,
                        children: [
                          Image.asset(AppAssets.dottedLine),
                          Text(
                            'أو',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  fontSize: 11.0,
                                ),
                          ),
                          Image.asset(AppAssets.dottedLine),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'بلّش تصفّح كضيف بدون حساب',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneField() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: CustomTextField(
        controller: _phoneController,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.neutral,
              fontFamily: 'Baloo2',
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
