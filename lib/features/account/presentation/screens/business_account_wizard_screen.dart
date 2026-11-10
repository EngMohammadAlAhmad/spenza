import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/app_bottom_container.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/core/widgets/app_scaffold.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/snackbar_service.dart';
import 'package:spenza/features/account/presentation/widgets/business_account_step1_widget.dart';
import 'package:spenza/features/account/presentation/widgets/business_account_step2_widget.dart';
import 'package:spenza/features/account/presentation/widgets/business_account_wizard_progress_bar.dart';

class BusinessAccountWizardScreen extends StatefulWidget {
  const BusinessAccountWizardScreen({super.key});

  @override
  State<BusinessAccountWizardScreen> createState() =>
      _BusinessAccountWizardScreenState();
}

class _BusinessAccountWizardScreenState
    extends State<BusinessAccountWizardScreen> {
  final _formKey = GlobalKey<FormState>();
  late final PageController _pageController;
  int _currentStep = 1;

  // Step 1 Form Controllers & State
  final _entityNameController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  final String _selectedActivity = '';
  final String _selectedMonthlyEstimate = '';

  // Step 2 Image State
  File? _projectImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentStep - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entityNameController.dispose();
    _storeNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _projectImage = File(picked.path);
        });
      }
    } catch (_) {
      if (mounted) {
        SnackbarService.showError(context, message: 'cannot_open_image'.tr());
      }
    }
  }

  void _onDeleteImage() {
    setState(() {
      _projectImage = null;
    });
  }

  void _goToNextStep() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  void _goToPreviousStep() {
    FocusScope.of(context).unfocus();
    if (_currentStep == 2) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      if (context.canPop()) {
        context.pop();
      } else {
        Navigator.of(context).maybePop();
      }
    }
  }

  Widget _buildAnimatedHeaderTitle(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            ...previousChildren,
            ? currentChild,
          ],
        );
      },
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.08),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Column(
        key: ValueKey<int>(_currentStep),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _currentStep == 1 ? 'entity_details'.tr() : 'project_photo'.tr(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2.0),
          Text(
            _currentStep == 1 ? 'step_1_of_2'.tr() : 'step_2_of_2'.tr(),
            style: const TextStyle(
              fontSize: 13.0,
              color: AppColors.neutral,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentStep == 1,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentStep == 2) {
          _goToPreviousStep();
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: AppScaffold(
          titleWidget: _buildAnimatedHeaderTitle(context),
          subtitle: _currentStep == 1 ? 'step_1_of_2'.tr() : 'step_2_of_2'.tr(),
          headerStyle: AppHeaderStyle.light,
          showBackButton: true,
          onBackPressed: _goToPreviousStep,
          bottomNavigationBar: AppBottomContainer(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
            child: CustomButton(
              text: _currentStep == 1
                  ? 'next_project_photo'.tr()
                  : 'submit_request'.tr(),
              height: 52.0,
              isLoading: false,
              onPressed: _currentStep == 1
                  ? _goToNextStep
                  : (_projectImage != null ? () {} : null),
            ),
          ),
          body: Column(
            children: [
              // Stepper Progress Bar
              BusinessAccountWizardProgressBar(currentStep: _currentStep),

              // Scrollable Form Body with PageView animation
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index + 1;
                    });
                  },
                  children: [
                    SingleChildScrollView(
                      key: const ValueKey('step_1_scroll_view'),
                      physics: const BouncingScrollPhysics(),
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 32.0),
                      child: BusinessAccountStep1Widget(
                        formKey: _formKey,
                        entityNameController: _entityNameController,
                        storeNameController: _storeNameController,
                        addressController: _addressController,
                        phoneController: _phoneController,
                        selectedActivity: _selectedActivity,
                        selectedMonthlyEstimate: _selectedMonthlyEstimate,
                      ),
                    ),
                    SingleChildScrollView(
                      key: const ValueKey('step_2_scroll_view'),
                      physics: const BouncingScrollPhysics(),
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 32.0),
                      child: BusinessAccountStep2Widget(
                        projectImage: _projectImage,
                        onPickImage: _pickImage,
                        onDeleteImage: _onDeleteImage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
