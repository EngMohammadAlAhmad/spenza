import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/core/widgets/custom_dialog.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  void _showFaqDialog(BuildContext context, String question, String answer) {
    AppCustomDialog.show(
      context: context,
      iconPath: AppAssets.questionIcon,
      title: question,
      description: answer,
      primaryButtonText: 'back'.tr(),
      onPrimaryPressed: () => Navigator.of(context, rootNavigator: true).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTabletLandscape = context.isTabletLandscape;

    // Header Illustration & Subtitle Section
    final illustrationSection = Column(
      children: [
        SvgPicture.asset(
          AppAssets.supportIllustration,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16.0),
        Text(
          'we_are_here_to_help'.tr(),
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: .w800,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'contact_us_subtitle'.tr(),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppColors.tertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );

    // Contact Action Cards (WhatsApp, Call, Email)
    final contactActionCards = Row(
      children: [
        _buildContactCard(
          context,
          iconPath: AppAssets.chatIcon,
          title: 'whatsapp'.tr(),
          onTap: () => () {},
        ),
        const SizedBox(width: 12.0),
        _buildContactCard(
          context,
          iconPath: AppAssets.phoneIcon,
          title: 'call'.tr(),
          onTap: () => () {},
        ),
        const SizedBox(width: 12.0),
        _buildContactCard(
          context,
          iconPath: AppAssets.mailIcon,
          title: 'message'.tr(),
          onTap: () => () {},
        ),
      ],
    );

    // FAQ List Section
    final faqSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0, bottom: 10.0),
          child: Text(
            'frequently_asked_questions'.tr(),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: .w800,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.extraLarge,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppRadius.extraLarge,
            child: Column(
              children: [
                _buildFaqItem(
                  context,
                  question: 'faq_delivery_time'.tr(),
                  isFirst: true,
                  onTap: () => _showFaqDialog(
                    context,
                    'faq_delivery_time'.tr(),
                    'faq_delivery_time_ans'.tr(),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    height: 1.0,
                    thickness: 0.8,
                    color: AppColors.neutral200,
                  ),
                ),
                _buildFaqItem(
                  context,
                  question: 'faq_transfer_payment'.tr(),
                  onTap: () => _showFaqDialog(
                    context,
                    'faq_transfer_payment'.tr(),
                    'faq_transfer_payment_ans'.tr(),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    height: 1.0,
                    thickness: 0.8,
                    color: AppColors.neutral200,
                  ),
                ),
                _buildFaqItem(
                  context,
                  question: 'faq_business_account'.tr(),
                  onTap: () => _showFaqDialog(
                    context,
                    'faq_business_account'.tr(),
                    'faq_business_account_ans'.tr(),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    height: 1.0,
                    thickness: 0.8,
                    color: AppColors.neutral200,
                  ),
                ),
                _buildFaqItem(
                  context,
                  question: 'faq_points_redemption'.tr(),
                  isLast: true,
                  onTap: () => _showFaqDialog(
                    context,
                    'faq_points_redemption'.tr(),
                    'faq_points_redemption_ans'.tr(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    Widget contentBody;

    if (isTabletLandscape) {
      contentBody = Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Physical LEFT side of screen: Actions & FAQ
            Expanded(
              child: Directionality(
                textDirection: Directionality.of(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    contactActionCards,
                    const SizedBox(height: 20.0),
                    faqSection,
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24.0),

            // Physical RIGHT side of screen: Illustration & Subtitle
            Expanded(
              child: Directionality(
                textDirection: Directionality.of(context),
                child: illustrationSection,
              ),
            ),
          ],
        ),
      );
    } else {
      contentBody = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          illustrationSection,
          const SizedBox(height: 24.0),
          contactActionCards,
          const SizedBox(height: 24.0),
          faqSection,
        ],
      );
    }

    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      body: Column(
        children: [
          AppHeader(
            title: 'help_and_support'.tr(),
            style: AppHeaderStyle.light,
            showBackButton: true,
            onBackPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                Navigator.of(context).maybePop();
              }
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
              child: contentBody,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, {
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.extraLarge,
        child: Container(
          height: 100.0,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.large,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            spacing: 10.0,
            mainAxisSize: .min,
            mainAxisAlignment: .center,
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: AppRadius.mediumPlus,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  iconPath,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: .bold,
                  color: AppColors.textBody,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, {
    required String question,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final itemRadius = BorderRadius.vertical(
      top: isFirst ? const Radius.circular(24.0) : Radius.zero,
      bottom: isLast ? const Radius.circular(24.0) : Radius.zero,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: itemRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            spacing: 12.0,
            children: [
              Container(
                width: 36.0,
                height: 36.0,
                decoration:  BoxDecoration(
                  color: AppColors.neutralBackground,
                  borderRadius: AppRadius.medium,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppAssets.questionIcon,
                  colorFilter: const ColorFilter.mode(
                    AppColors.neutral700,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  question,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: .bold,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.neutralBorderStrong,
                size: 18.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
