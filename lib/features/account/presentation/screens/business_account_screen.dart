import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/app_bottom_container.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/core/widgets/custom_button.dart';

class BusinessAccountScreen extends StatelessWidget {
  const BusinessAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTabletLandscape = context.isTabletLandscape;

    // Right Section: Hero Illustration, Title & Subtitle
    final heroSection = Column(
      children: [
        SvgPicture.asset(
          AppAssets.enterpriseIllustration,
        ),
        const SizedBox(height: 16.0),
        Text(
          'business_account_hero_title'.tr(),
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: AppColors.neutral900,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6.0),
        Text(
          'business_account_hero_subtitle'.tr(),
          style: const TextStyle(
            fontSize: 13.0,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );

    // Left Section: Features & Steps Cards
    final detailsSection = Column(
      children: [
        _buildFeaturesCard(context),
        const SizedBox(height: 16.0),
        _buildStepsCard(context),
      ],
    );

    Widget contentBody;

    if (isTabletLandscape) {
      contentBody = Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Physical LEFT side: Details Section (Features & Steps Cards)
            Expanded(
              child: Directionality(
                textDirection: Directionality.of(context),
                child: detailsSection,
              ),
            ),
            const SizedBox(width: 20.0),

            // Physical RIGHT side: Hero Section (Illustration, Title & Subtitle)
            Expanded(
              child: Directionality(
                textDirection: Directionality.of(context),
                child: heroSection,
              ),
            ),
          ],
        ),
      );
    } else {
      contentBody = Column(
        children: [
          heroSection,
          const SizedBox(height: 20.0),
          detailsSection,
        ],
      );
    }

    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      body: Column(
        children: [
          // Fixed Header
          _buildHeader(context),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 32.0),
              child: contentBody,
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomContainer(
        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
        child: CustomButton(
          text: 'start_request'.tr(),
          height: 52.0,
          onPressed: () => context.push(RoutePaths.businessAccountWizard),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return AppHeader(
      title: 'business_account'.tr(),
      style: AppHeaderStyle.light,
      showBackButton: true,
      onBackPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          Navigator.of(context).maybePop();
        }
      },
    );
  }

  Widget _buildFeaturesCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        spacing: 14.0,
        children: [
          _buildFeatureRow(
            iconPath: AppAssets.offersAndDiscountsIcon,
            title: 'business_feature_1_title'.tr(),
            subtitle: 'business_feature_1_sub'.tr(),
          ),
          _buildFeatureRow(
            iconPath: AppAssets.packageIcon,
            title: 'business_feature_2_title'.tr(),
            subtitle: 'business_feature_2_sub'.tr(),
          ),
          _buildFeatureRow(
            iconPath: AppAssets.truckIcon,
            title: 'business_feature_3_title'.tr(),
            subtitle: 'business_feature_3_sub'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow({
    required String iconPath,
    required String title,
    required String subtitle,
  }) {
    return Row(
      spacing: 12.0,
      children: [
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: AppColors.thirdAccent,
            borderRadius: AppRadius.medium,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            iconPath,
            width: 20.0,
            height: 20.0,
            colorFilter: const ColorFilter.mode(
              AppColors.blue,
              BlendMode.srcIn,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.0,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
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
          Text(
            'how_it_works'.tr(),
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          _buildStepRow('1', 'business_step_1'.tr()),
          _buildStepRow('2', 'business_step_2'.tr()),
          _buildStepRow('3', 'business_step_3'.tr()),
          _buildStepRow('4', 'business_step_4'.tr()),
        ],
      ),
    );
  }

  Widget _buildStepRow(String number, String text) {
    return Row(
      spacing: 12.0,
      children: [
        Container(
          width: 24.0,
          height: 24.0,
          decoration: const BoxDecoration(
            color: Color(0xFFFDE8E8),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFFC74436),
            ),
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral900,
          ),
        ),
      ],
    );
  }
}
