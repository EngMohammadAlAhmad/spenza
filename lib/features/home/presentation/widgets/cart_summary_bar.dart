import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/themes/app_radius.dart';

class CartSummaryBar extends StatelessWidget {
  const CartSummaryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.9),
        borderRadius: AppRadius.extraLarge2,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.3),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.overMedium,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Row(
              children: [
                const Icon(Icons.arrow_back_ios, size: 14),
                const SizedBox(width: 4),
                Text(
                  'عرض السلة',
                  style: AppTextStyles.button(context).copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '2 منتجات في سلتك',
                    style: AppTextStyles.bodySmall(context).copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '124,000 ل.س',
                    style: AppTextStyles.heading4(context).copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_basket_outlined,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '3',
                        style: AppTextStyles.bodySmall(context).copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
