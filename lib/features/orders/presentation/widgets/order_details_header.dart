import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF91292B),
            Color(0xFFC74436),
            Color(0xFFD46B60),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.0)),
      ),
      child: Stack(
        children: [
          // Background pattern overlay matching AccountHeader
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32.0),
              ),
              child: Image.asset(
                'assets/images/pattern.png',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.08),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Navigation Row
                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(8.0),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4.0,
                      children: [
                        Icon(
                          Icons.chevron_left_rounded,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        Text(
                          'تفاصيل الطلب',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  // Status and Order Header Row
                  Row(
                    spacing: 12.0,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 52.0,
                        height: 52.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/icons/package_icon.svg',
                        ),
                      ),
                      // Order Details Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_formatDate(order.placedAt)} · ${order.orderNumber}',
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
                                    : 'قيد الانتظار',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'اليوم';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final itemDate = DateTime(dt.year, dt.month, dt.day);

      final timeStr = DateFormat('h:mm a').format(dt).replaceAll('AM', 'ص').replaceAll('PM', 'م');

      if (itemDate == today) {
        return 'اليوم $timeStr';
      } else if (itemDate == yesterday) {
        return 'أمس $timeStr';
      } else {
        return '${DateFormat('yyyy/MM/dd').format(dt)} $timeStr';
      }
    } catch (_) {
      return 'اليوم';
    }
  }
}
