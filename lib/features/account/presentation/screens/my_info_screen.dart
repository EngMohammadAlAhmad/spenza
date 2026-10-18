import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';
import 'package:spenza/core/widgets/snackbar_service.dart';
import 'package:spenza/features/account/domain/entities/user_entity.dart';
import 'package:spenza/features/account/presentation/blocs/my_info_bloc/my_info_bloc.dart';
import 'package:spenza/features/account/presentation/blocs/my_info_bloc/my_info_event.dart';
import 'package:spenza/features/account/presentation/blocs/my_info_bloc/my_info_state.dart';
import 'package:spenza/features/account/presentation/screens/phone_change_otp_screen.dart';
import 'package:spenza/injection_locator.dart';

class MyInfoScreen extends StatelessWidget {
  final UserEntity? user;

  const MyInfoScreen({
    super.key,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyInfoBloc>(
      create: (context) => sl<MyInfoBloc>(),
      child: _MyInfoContent(initialUser: user),
    );
  }
}

class _MyInfoContent extends StatefulWidget {
  final UserEntity? initialUser;

  const _MyInfoContent({this.initialUser});

  @override
  State<_MyInfoContent> createState() => _MyInfoContentState();
}

class _MyInfoContentState extends State<_MyInfoContent> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _newPhoneController = TextEditingController();

  UserEntity? _currentUser;
  bool _isPhoneChangeExpanded = false;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.initialUser;
    _nameController = TextEditingController(text: _currentUser?.name ?? '');
    _emailController = TextEditingController(text: _currentUser?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _newPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      body: BlocConsumer<MyInfoBloc, MyInfoState>(
        listener: (context, myInfoState) {
          // 1. Profile Update Listener
          if (myInfoState.updateProfileStatus == RequestStatus.success) {
            SnackbarService.showSuccess(context, message: 'تم حفظ التغييرات بنجاح');
            context.pop(myInfoState.user);
          } else if (myInfoState.updateProfileStatus == RequestStatus.error) {
            SnackbarService.showError(
              context,
              message: myInfoState.errorMessage ?? 'تعذر تحديث البيانات',
            );
          }

          // 2. Phone Change Request Listener
          if (myInfoState.requestPhoneStatus == RequestStatus.success) {
            SnackbarService.showSuccess(
              context,
              message: myInfoState.phoneChangeMessage ?? 'رمز التحقق في طريقه إلى هاتفك.',
            );

            final rawPhone = _newPhoneController.text.replaceAll(' ', '');
            final formattedPhone = rawPhone.startsWith('0') ? rawPhone.substring(1) : rawPhone;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<MyInfoBloc>(),
                  child: PhoneChangeOtpScreen(phoneNumber: formattedPhone),
                ),
              ),
            ).then((result) {
              if (result != null && result != false) {
                if (context.mounted) {
                  context.pop(result);
                }
              }
            });
          } else if (myInfoState.requestPhoneStatus == RequestStatus.error) {
            SnackbarService.showError(
              context,
              message: myInfoState.errorMessage ?? 'حدث خطأ أثناء طلب تغيير الرقم',
            );
          }
        },
        builder: (context, myInfoState) {
          final isSaving = myInfoState.updateProfileStatus == RequestStatus.loading;
          final isRequestingPhone = myInfoState.requestPhoneStatus == RequestStatus.loading;

          return Column(
            children: [
              // Header
              _buildHeader(context),

              // Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 18.0,
                    children: [
                      // 1. Full Name Field
                      _buildTextFieldSection(
                        label: 'الاسم الكامل',
                        controller: _nameController,
                        hintText: 'أدخل اسمك الكامل',
                      ),

                      // 2. Email Field (Optional)
                      _buildTextFieldSection(
                        label: 'البريد الإلكتروني (اختياري)',
                        controller: _emailController,
                        hintText: 'example@domain.com',
                        keyboardType: TextInputType.emailAddress,
                      ),

                      // 3. Mobile Number Section
                      _buildMobileNumberSection(context, _currentUser),

                      // 4. Expandable Phone Change Dropdown
                      if (_isPhoneChangeExpanded)
                        _buildPhoneChangeDropdown(context, isRequestingPhone),

                      // 5. Account Type Banner
                      _buildAccountTypeBanner(_currentUser),

                      const SizedBox(height: 10.0),

                      // 6. Save Button
                      CustomButton(
                        text: 'احفظ التغييرات',
                        height: 52.0,
                        isLoading: isSaving,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          final name = _nameController.text.trim();
                          final email = _emailController.text.trim();

                          if (name.isEmpty) {
                            SnackbarService.showError(context, message: 'يرجى إدخال الاسم الكامل');
                            return;
                          }

                          context.read<MyInfoBloc>().add(UpdateProfileEvent(
                                name: name,
                                email: email,
                              ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0.0, 5.0),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12.0,
        bottom: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12.0,
            children: [
              InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.neutral900,
                    size: 24.0,
                  ),
                ),
              ),
              const Text(
                'معلوماتي',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldSection({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return CustomTextField(
      controller: controller,
      label: label,
      labelStyle: const TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.bold,
        color: AppColors.neutral900,
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 14.0,
        color: AppColors.textSecondary,
      ),
      keyboardType: keyboardType,
      fillColor: Colors.white,
      borderColor: const Color(0xFFF3F4F6),
      style: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: AppColors.neutral900,
      ),
    );
  }

  Widget _buildMobileNumberSection(BuildContext context, UserEntity? user) {
    final phoneText = user != null ? user.formattedPhoneNumber : '----------------';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        const Text(
          'رقم الموبايل',
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            color: AppColors.neutral900,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Phone & Verified Icon
              Row(
                spacing: 8.0,
                children: [
                  SvgPicture.asset('assets/icons/shield_icon.svg'),
                  Text(
                    phoneText,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.textBody,
                    ),
                  ),
                ],
              ),

              // Change Phone Button
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _isPhoneChangeExpanded = !_isPhoneChangeExpanded;
                  });
                },
                child: Text(
                  _isPhoneChangeExpanded ? 'إلغاء' : 'غيّر الرقم',
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC74436),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneChangeDropdown(BuildContext context, bool isLoading) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFC74436).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.0,
        children: [
          const Text(
            'أدخل رقم الموبايل الجديد',
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: CustomTextField(
              controller: _newPhoneController,
              hintText: '9xx xxx xxx',
              forPhone: true,
              fillColor: const Color(0xFFF9FAFB),
              borderColor: const Color(0xFFE5E7EB),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _PhoneInputFormatter(),
              ],
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
                    width: 20.0,
                    height: 48.0,
                    child: VerticalDivider(
                      color: AppColors.primaryLight.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomButton(
            text: 'إرسال رمز التحقق',
            height: 46.0,
            isLoading: isLoading,
            onPressed: () {
              FocusScope.of(context).unfocus();
              final raw = _newPhoneController.text.replaceAll(' ', '');
              if (raw.length < 9) {
                SnackbarService.showError(context, message: 'يرجى إدخال رقم موبايل صحيح من 9 أرقام');
                return;
              }
              final fullPhone = raw.startsWith('0') ? raw : '0$raw';
              context.read<MyInfoBloc>().add(RequestPhoneChangeEvent(phoneNumber: fullPhone));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTypeBanner(UserEntity? user) {
    final roleLabel = user != null && user.roleLabel.isNotEmpty ? user.roleLabel : 'شخصي';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.thirdAccent,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.0,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.blue,
            size: 22.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.0,
              children: [
                Text(
                  'نوع الحساب: $roleLabel',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
                const Text(
                  'حساب شخصي. لتحويله لحساب أعمال، قدم طلب من صفحة حسابي.',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF475569),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
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
