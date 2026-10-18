import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/snackbar_service.dart';
import 'package:spenza/features/account/presentation/blocs/my_info_bloc/my_info_bloc.dart';
import 'package:spenza/features/account/presentation/blocs/my_info_bloc/my_info_event.dart';
import 'package:spenza/features/account/presentation/blocs/my_info_bloc/my_info_state.dart';

class PhoneChangeOtpScreen extends StatefulWidget {
  final String phoneNumber;

  const PhoneChangeOtpScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<PhoneChangeOtpScreen> createState() => _PhoneChangeOtpScreenState();
}

class _PhoneChangeOtpScreenState extends State<PhoneChangeOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendCountdown = 59;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    for (var node in _focusNodes) {
      node.addListener(() => setState(() {}));
    }
    _startTimer();
  }

  void _startTimer() {
    _resendCountdown = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  bool get _isOtpComplete => _controllers.every((c) => c.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.neutral900),
          onPressed: () => context.pop(false),
        ),
      ),
      body: BlocConsumer<MyInfoBloc, MyInfoState>(
        listenWhen: (previous, current) =>
            previous.confirmPhoneStatus != current.confirmPhoneStatus,
        listener: (context, state) {
          if (state.confirmPhoneStatus == RequestStatus.success) {
            SnackbarService.showSuccess(context, message: 'تم تغيير رقم الموبايل بنجاح');
            context.pop(state.user ?? true);
          } else if (state.confirmPhoneStatus == RequestStatus.error) {
            SnackbarService.showError(context, message: state.errorMessage ?? 'حدث خطأ أثناء تأكيد الرقم');
          }
        },
        builder: (context, state) {
          final isLoading = state.confirmPhoneStatus == RequestStatus.loading;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
            child: Column(
              spacing: 24.0,
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
                        text: '+963${widget.phoneNumber}',
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
                // OTP Input Boxes
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
                          text: '00:${_resendCountdown.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    style: const TextStyle(color: AppColors.neutral, fontSize: 13.0),
                  ),
                ),
                if (_resendCountdown == 0)
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.read<MyInfoBloc>().add(RequestPhoneChangeEvent(phoneNumber: widget.phoneNumber));
                        _startTimer();
                      },
                      child: const Text(
                        'إعادة إرسال الرمز',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12.0),
                CustomButton(
                  text: 'تحقّق',
                  height: 52.0,
                  isLoading: isLoading,
                  onPressed: _isOtpComplete && !isLoading
                      ? () {
                          FocusScope.of(context).unfocus();
                          final code = _controllers.map((c) => c.text).join();
                          context.read<MyInfoBloc>().add(ConfirmPhoneChangeEvent(
                                phoneNumber: widget.phoneNumber,
                                code: code,
                              ));
                        }
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOTPBox(int index) {
    return SizedBox(
      width: 48.0,
      height: 56.0,
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
