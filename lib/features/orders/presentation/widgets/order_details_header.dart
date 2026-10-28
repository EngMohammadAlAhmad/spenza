import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/features/orders/domain/entities/order_details_entity.dart';
import 'package:spenza/features/orders/presentation/widgets/animated_three_dots.dart';

class OrderDetailsHeader extends StatelessWidget {
  final OrderDetailsEntity order;

  const OrderDetailsHeader({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      style: AppHeaderStyle.gradient,
      titleWidget: InkWell(
        onTap: () => context.pop(),
        borderRadius: AppRadius.small,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4.0,
          children: [
            const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 24.0,
            ),
            Text(
              'order_details'.tr(),
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      showBackButton: false,
      padding: EdgeInsets.only(
        top: context.screenPadding.top + 16.0,
        left: 20.0,
        right: 20.0,
        bottom: 24.0,
      ),
      bottomChild: Row(
        spacing: 12.0,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 52.0,
            height: 52.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.overMedium,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0.0, 4.0),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppAssets.packageIcon,
            ),
          ),
          // Order Details Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_formatDate(context, order.placedAt)} · ${order.orderNumber}',
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    order.statusLabel.isNotEmpty
                        ? order.statusLabel
                        : 'pending'.tr(),
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (order.statusLabel.isEmpty ||
                      order.statusLabel.contains('انتظار') ||
                      order.status.toLowerCase() == 'pending') ...[
                    const SizedBox(width: 8.0),
                    const AnimatedThreeDots(color: Colors.white),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, String dateStr) {
    if (dateStr.isEmpty) return 'today'.tr();
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final itemDate = DateTime(dt.year, dt.month, dt.day);

      final isAr = context.locale.languageCode == 'ar';
      final formattedTime = DateFormat('h:mm a').format(dt);
      final timeStr = isAr
          ? formattedTime.replaceAll('AM', 'ص').replaceAll('PM', 'م')
          : formattedTime;

      if (itemDate == today) {
        return '${'today'.tr()} $timeStr';
      } else if (itemDate == yesterday) {
        return '${'yesterday'.tr()} $timeStr';
      } else {
        return '${DateFormat('yyyy/MM/dd').format(dt)} $timeStr';
      }
    } catch (_) {
      return 'today'.tr();
    }
  }
}
