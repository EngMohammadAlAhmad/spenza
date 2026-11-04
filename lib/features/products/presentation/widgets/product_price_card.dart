import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';

class ProductPriceCard extends StatelessWidget {
  final num currentPrice;
  final num originalPrice;
  final bool hasDiscount;
  final String unitTitle;
  final NumberFormat formatter;

  const ProductPriceCard({
    super.key,
    required this.currentPrice,
    required this.originalPrice,
    required this.hasDiscount,
    required this.unitTitle,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.overMedium,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main Price Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  if (hasDiscount) ...[
                    Text(
                      formatter.format(originalPrice),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.neutral,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                  ],
                  Text(
                    '${formatter.format(currentPrice)} ',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'sp_currency'.tr(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Text(
                'for_unit_prefix'.tr(args: [unitTitle]),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.neutral700,
                    ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(
              height: 1.0,
              thickness: 1.0,
              color: AppColors.neutral200.withValues(alpha: 0.6),
            ),
          ),

          // Business Wholesale Callout Banner
          InkWell(
            onTap: () => context.push(RoutePaths.businessAccount),
            borderRadius: AppRadius.medium,
            child: Row(
              spacing: 10.0,
              children: [
                Container(
                  width: 36.0,
                  height: 36.0,
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint,
                    borderRadius: AppRadius.medium,
                  ),
                  child: SvgPicture.asset(
                    AppAssets.shoppingIcon,
                    colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'buying_for_business'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      'open_business_account_desc'.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.tertiary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'order_now'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primary,
                  size: 15.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
