import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/features/orders/presentation/widgets/order_help_bottom_sheet.dart';

class OrderDetailsInvoiceCard extends StatelessWidget {
  final ValueChanged<OrderHelpType>? onHelpOptionSelected;
  final String? orderNumber;
  final String? orderStatus;

  const OrderDetailsInvoiceCard({
    super.key,
    this.onHelpOptionSelected,
    this.orderNumber,
    this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.upMedium,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        spacing: 15.0,
        children: [
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10.0,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: AppRadius.ordinary,
                    ),
                    child: SvgPicture.asset(AppAssets.bellIcon),
                  ),
                  const Text(
                    'الفاتورة',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                    ),
                  ),
                ],
              ),
              const Row(
                spacing: 4.0,
                children: [
                  Text(
                    'بتصدر بعد التسليم',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18.0,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),*/
          InkWell(
            onTap: () {
              OrderHelpBottomSheet.show(
                context,
                onOptionSelected: onHelpOptionSelected,
                orderNumber: orderNumber,
                orderStatus: orderStatus,
              );
            },
            borderRadius: AppRadius.ordinary,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 10.0,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: AppRadius.ordinary,
                        ),
                        child: SvgPicture.asset(AppAssets.questionIcon),
                      ),
                      const Text(
                        'مساعدة بهالطلب',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutral900,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20.0,
                    color: AppColors.neutral900,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
