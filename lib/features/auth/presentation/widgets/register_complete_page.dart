import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';
import 'package:spenza/core/widgets/snackbar_service.dart';
import 'package:spenza/features/auth/domain/entities/auth_result_entity.dart';
import 'package:spenza/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:spenza/features/auth/presentation/bloc/auth_event.dart';
import 'package:spenza/injection_locator.dart';

class RegisterCompletePage extends StatefulWidget {
  final String phoneNumber;
  final String code;

  const RegisterCompletePage({
    super.key,
    required this.phoneNumber,
    required this.code,
  });

  @override
  State<RegisterCompletePage> createState() => _RegisterCompletePageState();
}

class _RegisterCompletePageState extends State<RegisterCompletePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, BaseState<Object>>(
        listener: (context, state) {
          if (state.isSuccess && state.data is AuthResultEntity) {
            SnackbarService.showSuccess(context, message: (state.data as AuthResultEntity).message);
            context.go(RoutePaths.home);
          } else if (state.isError) {
            SnackbarService.showError(context, message: state.errorMessage);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'يلا نساوي حساب سوا',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'اسمك بكفّي لنجهّز حسابك ونوصّل\nطلباتك بسرعة.',
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
                        fontWeight: FontWeight.bold,
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
                  isLoading: state.isLoading,
                  onPressed: (_agreedToTerms && _nameController.text.trim().isNotEmpty && !state.isLoading)
                      ? () {
                          context.read<AuthBloc>().add(RegisterEvent(
                                name: _nameController.text.trim(),
                                phoneNumber: '0${widget.phoneNumber}',
                                code: widget.code,
                              ));
                        }
                      : null,
                ),

                const SizedBox(height: 25.0),

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

                const SizedBox(height: 8.0),

                Center(
                  child: TextButton(
                    onPressed: () => context.go(RoutePaths.home),
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
        },
      ),
    );
  }
}
