import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';

class Step3PaymentSummaryCard extends StatelessWidget {
  final String paymentMethod; // 'cash', 'bank', 'paymera'
  final VoidCallback onEditPressed;

  const Step3PaymentSummaryCard({
    super.key,
    required this.paymentMethod,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    String title = 'كاش عند الاستلام';
    String subtitle = 'جهز المبلغ للمندوب، وبتوصلك الفاتورة بعد التسليم.';

    if (paymentMethod == 'bank') {
      title = 'حوالة بنكية';
      subtitle = 'بتحول وبترفع صورة الوصل، ومنتأكد الدفع بعد المراجعة.';
    } else if (paymentMethod == 'paymera') {
      title = 'بيميرا';
      subtitle = 'دفع إلكتروني مباشر.';
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.upMedium,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    AppAssets.paymentIcon,
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    'الدفع',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onEditPressed,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.editIcon,
                      colorFilter: .mode(AppColors.primary, .srcIn),
                    ),
                    const SizedBox(width: 4.0),
                    const Text(
                      'تعديل',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),

          // Payment Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 4.0),

          // Payment Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13.0,
              color: AppColors.neutral,
            ),
          ),
        ],
      ),
    );
  }
}
