import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/widgets/custom_button.dart';

class BusinessAccountScreen extends StatelessWidget {
  const BusinessAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                children: [
                  // Illustration
                  SvgPicture.asset(
                    'assets/images/enterprise_illustration.svg',
                  ),
                  const SizedBox(height: 16.0),

                  // Title & Subtitle
                  const Text(
                    'حساب على قد شغلك',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6.0),
                  const Text(
                    'للمكتبات والشركات والمؤسسات الخاصة أو\nالحكومية والجمعيات. قدم طلب ومنراجعه\nمعك.',
                    style: TextStyle(
                      fontSize: 13.0,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),

                  // Features Card
                  _buildFeaturesCard(context),
                  const SizedBox(height: 16.0),

                  // How it works Card
                  _buildStepsCard(context),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),

          // Fixed Bottom White Container with "ابدأ الطلب" Button
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        20.0,
        16.0,
        20.0,
        MediaQuery.of(context).padding.bottom > 0
            ? MediaQuery.of(context).padding.bottom + 8.0
            : 20.0,
      ),
      child: CustomButton(
        text: 'ابدأ الطلب',
        height: 52.0,
        onPressed: () {
          // Business account request start action
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
                borderRadius: AppRadius.large,
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
                'حساب أعمال',
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
            iconPath: 'assets/icons/offers_and_discounts_icon.svg',
            title: 'أسعار وكميات على قد طلباتكن',
            subtitle: 'حسب نوع نشاطك وقرار الإدارة',
          ),
          _buildFeatureRow(
            iconPath: 'assets/icons/package_icon.svg',
            title: 'وحدات بيع أكبر',
            subtitle: 'طرد وكرتونة للكميات الكبيرة',
          ),
          _buildFeatureRow(
            iconPath: 'assets/icons/truck_icon.svg',
            title: 'نفس الطلب والتوصيل',
            subtitle: 'وبتضل تشوف طلباتك ونقاطك مثل ما هي',
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
          const Text(
            'كيف بتمشي',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          _buildStepRow('1', 'بتعبي بيانات الجهة'),
          _buildStepRow('2', 'بترفع صورة لمحلك أو مشروعك'),
          _buildStepRow('3', 'منتصل فيك ومنراجع الطلب'),
          _buildStepRow('4', 'منبلغك بالنتيجة'),
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
