import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';

class OrderCard extends StatelessWidget {
  final OrderResponseEntity order;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');
    final statusStyle = _getStatusStyle(order);
    final actionLabel = _getActionLabel(order);

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.0),
        child: InkWell(
          onTap: onTap ?? () => context.push(RoutePaths.orderDetails, extra: order.orderNumber),
          borderRadius: BorderRadius.circular(18.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Order Number & Date/Items
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.orderNumber,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          '${_formatDate(order.placedAt)} · ${order.itemsCount} ${order.itemsCount == 1 ? 'منتج' : 'منتجات'}',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8.0),

                        // Item Thumbnails
                        _buildThumbnails(order.itemImages),
                      ],
                    ),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: statusStyle.backgroundColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        order.statusLabel.isNotEmpty
                            ? order.statusLabel
                            : 'قيد الانتظار',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: statusStyle.textColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF3F4F6),
                  ),
                ),

                // Bottom Row: Action Button (left) & Total + Payment Label (right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Total Price & Payment Method
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${formatter.format(order.totalAmount)} ل.س',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          order.paymentMethodLabel.isNotEmpty
                              ? order.paymentMethodLabel
                              : 'كاش عند الاستلام',
                          style: const TextStyle(
                            fontSize: 11.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    // Action CTA
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 2.0,
                      children: [
                        Text(
                          actionLabel,
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFC74436),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 18.0,
                          color: Color(0xFFC74436),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnails(List<String> images) {
    if (images.isNotEmpty) {
      final displayImages = images.take(3).toList();
      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6.0,
        children: displayImages.map((url) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              url,
              width: 36.0,
              height: 36.0,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _buildPlaceholderSquare(),
            ),
          );
        }).toList(),
      );
    }

    // Default placeholder product thumbnails matching mockup style
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6.0,
      children: List.generate(
        order.itemsCount > 3 ? 3 : (order.itemsCount > 0 ? order.itemsCount : 1),
        (_) => _buildPlaceholderSquare(),
      ),
    );
  }

  Widget _buildPlaceholderSquare() {
    return SvgPicture.asset('assets/icons/products_icon.svg', height: 44.0, width: 44.0);
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'اليوم';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final itemDate = DateTime(dt.year, dt.month, dt.day);

      if (itemDate == today) {
        return 'اليوم';
      } else if (itemDate == yesterday) {
        return 'أمس';
      } else {
        return DateFormat('yyyy/MM/dd').format(dt);
      }
    } catch (_) {
      return 'اليوم';
    }
  }

  _StatusStyle _getStatusStyle(OrderResponseEntity order) {
    final status = order.status.toLowerCase();
    final label = order.statusLabel;

    if (status.contains('prep') || label.contains('تجهيز') || status == 'processing') {
      return _StatusStyle(
        backgroundColor: const Color(0xFFEEF2FF),
        textColor: const Color(0xFF4F46E5),
      );
    } else if (status.contains('transfer') || label.contains('حوالة') || label.contains('تأكيد')) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFFEF3C7),
        textColor: const Color(0xFFB45309),
      );
    } else if (status.contains('courier') || label.contains('مندوب') || label.contains('توصيل')) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFFEE2E2),
        textColor: const Color(0xFFDC2626),
      );
    } else if (order.isCompleted || status.contains('deliver') || label.contains('مكتمل') || label.contains('استلام')) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFD1FAE5),
        textColor: const Color(0xFF059669),
      );
    } else if (status.contains('cancel') || label.contains('ملغى')) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFF3F4F6),
        textColor: const Color(0xFF6B7280),
      );
    }

    return _StatusStyle(
      backgroundColor: const Color(0xFFEEF2FF),
      textColor: const Color(0xFF3B82F6),
    );
  }

  String _getActionLabel(OrderResponseEntity order) {
    final label = order.statusLabel;
    if (label.contains('حوالة') || order.needsPaymentReview || label.contains('دفعه')) {
      return 'حالة الدفع';
    } else if (label.contains('مندوب') || label.contains('توصيل')) {
      return 'تتبع الطلب';
    }
    return 'تفاصيل الطلب';
  }
}

class _StatusStyle {
  final Color backgroundColor;
  final Color textColor;

  _StatusStyle({
    required this.backgroundColor,
    required this.textColor,
  });
}
