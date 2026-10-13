import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/snackbar_service.dart';
import 'package:spenza/features/auth/domain/entities/verify_otp_result_entity.dart';
import 'package:spenza/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:spenza/features/auth/presentation/bloc/auth_event.dart';
import 'package:spenza/injection_locator.dart';

class VerifyOtpPage extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback onEditPhone;
  final Function(String) onUnregistered;

  const VerifyOtpPage({
    super.key,
    required this.phoneNumber,
    required this.onEditPhone,
    required this.onUnregistered,
  });

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    for (var node in _focusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, BaseState<Object>>(
        listener: (context, state) {
          if (state.isSuccess && state.data is VerifyOtpResultEntity) {
            final result = state.data as VerifyOtpResultEntity;
            SnackbarService.showSuccess(context, message: result.message);
            if (result.registered) {
              context.go(RoutePaths.home);
            } else {
              final code = _controllers.map((c) => c.text).join();
              widget.onUnregistered(code);
            }
          } else if (state.isError) {
            SnackbarService.showError(context, message: state.errorMessage);
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 24.0),
                      child: Column(
                        spacing: 25.0,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'شو الرمز يلي وصلك؟',
                            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'بعتنالك رمز من 6 أرقام على ',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: AppColors.neutral,
                                      ),
                                ),
                                TextSpan(
                                  text: '963${widget.phoneNumber}+',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.blue,
                                    fontFamily: 'Baloo2',
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 15.0, color: AppColors.neutral, height: 1.4),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'الرقم غلط؟ ',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: AppColors.neutral,
                                        fontSize: 13.0,
                                      ),
                                ),
                                TextSpan(
                                  text: 'غيّر الرقم',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = widget.onEditPhone,
                                ),
                              ],
                            ),
                          ),
                          // OTP Fields
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(6, (index) => _buildOTPBox(index)),
                            ),
                          ),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(text: 'ما وصل الرمز؟ ابعتلي ياه مرة تانية بعد '),
                                  TextSpan(
                                    text: '00:58',
                                    style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              style: const TextStyle(color: AppColors.neutral, fontSize: 13.0),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          CustomButton(
                            text: 'تحقّق',
                            height: 52.0,
                            isLoading: state.isLoading,
                            onPressed: _isOtpComplete && !state.isLoading
                                ? () {
                                    final code = _controllers.map((c) => c.text).join();
                                    final phone = '0${widget.phoneNumber}';
                                    context.read<AuthBloc>().add(VerifyOtpEvent(
                                          phoneNumber: phone,
                                          code: code,
                                        ));
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  bool get _isOtpComplete => _controllers.every((c) => c.text.isNotEmpty);

  Widget _buildOTPBox(int index) {
    return SizedBox(
      width: 50.0, // Reduced width slightly to fit 6 boxes
      height: 58.0,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        maxLength: 1,
        expands: true,
        maxLines: null,
        minLines: null,
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontSize: 22.0,
        ),
        decoration: InputDecoration(
          counterText: '',
          isCollapsed: true,
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: AppRadius.brandRadius,
            borderSide: BorderSide(color: AppColors.primaryLight.withValues(alpha: 0.5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.brandRadius,
            borderSide: BorderSide(color: AppColors.primaryLight.withValues(alpha: 0.5)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: AppRadius.brandRadius,
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          setState(() {});
        },
      ),
    );
  }
}
