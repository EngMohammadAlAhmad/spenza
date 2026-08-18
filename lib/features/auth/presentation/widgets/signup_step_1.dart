import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';

class SignupStep1 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onLogin;

  const SignupStep1({super.key, required this.onNext, required this.onLogin});

  @override
  State<SignupStep1> createState() => _SignupStep1State();
}

class _SignupStep1State extends State<SignupStep1> {
  final TextEditingController _nameController = TextEditingController();
  bool _agreedToTerms = false;
  String? _selectedGovernorate;

  final List<String> _governorates = [
    'دمشق',
    'ريف دمشق',
    'حلب',
    'حمص',
    'حماة',
    'اللاذقية',
    'طرطوس',
    'إدلب',
    'دير الزور',
    'الرقة',
    'الحسكة',
    'درعا',
    'السويداء',
    'القنيطرة',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const inputBorder = OutlineInputBorder(
      borderRadius: AppRadius.brandRadius,
      borderSide: BorderSide(color: AppColors.neutral200),
    );

    return SingleChildScrollView(
      padding: const .fromLTRB(24.0, 60.0, 24.0, 10.0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            '1/3',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.primary,
              fontWeight: .bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'يلا نساوي حساب سوا',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.primary,
              fontWeight: .w700,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            'اسمك ومحافظتك بكفّوا لنجهّز حسابك ونوصّل\nطلباتك بسرعة.',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.neutral,
            ),
          ),
          const SizedBox(height: 32.0),

          // Full Name
          Text(
            'اسمك الكامل',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: .bold,
              color: Colors.black,
              fontSize: 13.0,
            ),
          ),
          const SizedBox(height: 12.0),
          CustomTextField(
            controller: _nameController,
            hintText: 'مثلاً: عبدالله القبّاني',
            textDirection: TextDirection.rtl,
            fillColor: Colors.white,
            borderColor: AppColors.primaryLight.withValues(alpha: 0.5),
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 24.0),

          // Governorate
          Text(
            'المحافظة',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: .bold,
              color: Colors.black,
              fontSize: 13.0,
            ),
          ),
          const SizedBox(height: 12.0),
          DropdownButtonFormField<String>(
            initialValue: _selectedGovernorate,
            hint: const Text('اختر المحافظة', style: TextStyle(color: AppColors.neutral)),
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: AppRadius.brandRadius,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: inputBorder,
              enabledBorder: inputBorder,
              focusedBorder: inputBorder.copyWith(
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.neutral),
            items: _governorates.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(value, style: const TextStyle(fontFamily: 'Zain')),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedGovernorate = newValue;
              });
            },
          ),

          const SizedBox(height: 24.0),
          
          // Terms
          Row(
            spacing: 8.0,
            children: [
              GestureDetector(
                onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                child: Container(
                  height: 20.0,
                  width: 20.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _agreedToTerms ? AppColors.primary : Colors.white,
                    border: Border.all(
                      color: _agreedToTerms ? AppColors.primary : AppColors.neutral200,
                      width: 1.5,
                    ),
                  ),
                  child: _agreedToTerms
                      ? const Icon(
                          Icons.check,
                          size: 14.0,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'قريت وبوافق على '),
                      TextSpan(
                        text: 'شروط الاستخدام',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: ' و '),
                      TextSpan(
                        text: 'سياسة الخصوصية',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 13.0, color: AppColors.neutral),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40.0),
          
          // Continue Button
          CustomButton(
            text: 'كمّل',
            height: 52.0,
            onPressed: (_agreedToTerms &&
                    _selectedGovernorate != null &&
                    _nameController.text.trim().isNotEmpty)
                ? widget.onNext
                : null,
          ),
          
          const SizedBox(height: 24.0),
          
          // Footer
          Center(
            child: TextButton(
              onPressed: widget.onLogin,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: 'عندك حساب؟ ',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: AppColors.neutral,
                              fontSize: 11.0,
                            )),
                    TextSpan(
                        text: 'سجل الدخول',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.primary,
                              fontWeight: .bold,
                            )),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8.0),
          
          Center(
            child: Row(
              mainAxisAlignment: .center,
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
          
          const SizedBox(height: 8.0),
          
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'بلّش تصفّح كضيف بدون حساب',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
