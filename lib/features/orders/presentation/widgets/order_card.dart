import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';
import 'package:spenza/features/orders/presentation/utils/order_localization_helper.dart';

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
    final paymentStatusStyle = _getPaymentStatusStyle(order);
    final actionLabel = _getActionLabel(order);

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.upMedium,
        child: InkWell(
          onTap: onTap ?? () => context.push(RoutePaths.orderDetails, extra: order.orderNumber),
          borderRadius: AppRadius.upMedium,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Order Number & Date/Items
                    Expanded(
                      child: Column(
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
                            '${_formatDate(order.placedAt)} · ${order.itemsCount} ${order.itemsCount == 1 ? 'item_unit'.tr() : 'items_unit'.tr()}',
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
                    ),
                    const SizedBox(width: 8.0),
                    // Order Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: statusStyle.backgroundColor,
                        borderRadius: AppRadius.medium,
                      ),
                      child: Text(
                        order.statusLabel.isNotEmpty
                            ? order.statusLabel
                            : 'pending'.tr(),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Total Price & Payment Method + Payment Status Badge Row
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${formatter.format(order.totalAmount)} ${'sp_currency'.tr()}',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3.0),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              order.paymentMethodLabel.isNotEmpty
                                  ? order.paymentMethodLabel
                                  : 'cash_on_delivery_title'.tr(),
                              style: const TextStyle(
                                fontSize: 11.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (order.paymentStatusLabel.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Container(
                                  width: 4.0,
                                  height: 4.0,
                                  decoration: const BoxDecoration(
                                    color: AppColors.textSecondary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                  vertical: 2.0,
                                ),
                                decoration: BoxDecoration(
                                  color: paymentStatusStyle.backgroundColor,
                                  borderRadius: AppRadius.large,
                                ),
                                child: Row(
                                  spacing: 3.0,
                                  children: [
                                    Text(
                                      order.paymentStatusLabel,
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
                                        color: paymentStatusStyle.textColor,
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      AppAssets.cashIcon,
                                      height: 20.0,
                                      width: 20.0,
                                      colorFilter: .mode(AppColors.successForeground, .srcIn),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
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
    final Widget thumbnailsRow;

    if (images.isNotEmpty) {
      thumbnailsRow = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6.0,
          children: images.map((url) {
            return ClipRRect(
              borderRadius: AppRadius.small,
              child: Image.network(
                url,
                width: 36.0,
                height: 36.0,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildPlaceholderSquare(),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      final count = order.itemsCount > 0 ? order.itemsCount : 1;
      thumbnailsRow = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6.0,
          children: List.generate(
            count,
            (_) => _buildPlaceholderSquare(),
          ),
        ),
      );
    }

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Colors.black,
            Colors.black,
            Colors.transparent,
          ],
          stops: [0.0, 0.75, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: thumbnailsRow,
    );
  }

  Widget _buildPlaceholderSquare() {
    return SvgPicture.asset(AppAssets.productsIcon, height: 44.0, width: 44.0);
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'today'.tr();
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final itemDate = DateTime(dt.year, dt.month, dt.day);

      if (itemDate == today) {
        return 'today'.tr();
      } else if (itemDate == yesterday) {
        return 'yesterday'.tr();
      } else {
        return DateFormat('yyyy/MM/dd').format(dt);
      }
    } catch (_) {
      return 'today'.tr();
    }
  }

  _StatusStyle _getStatusStyle(OrderResponseEntity order) {
    final status = order.status.toLowerCase();
    final label = order.statusLabel;

    // 1. Cancelled / Failed / Rejected MUST be checked FIRST
    if (status.contains('cancel') ||
        status.contains('fail') ||
        status.contains('reject') ||
        label.contains('ملغ') || // matches ملغى, ملغي, ملغاة
        label.contains('إلغاء') ||
        label.contains('مرفوض')) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFFEE2E2),
        textColor: const Color(0xFFDC2626),
      );
    }

    // 2. Completed / Delivered
    if (order.isCompleted ||
        status == 'completed' ||
        status == 'delivered' ||
        status.contains('deliver') ||
        label.contains('مكتمل') ||
        label.contains('استلام')) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFD1FAE5),
        textColor: const Color(0xFF059669),
      );
    }

    // 3. Courier / Out for Delivery
    if (status.contains('courier') ||
        label.contains('مندوب') ||
        label.contains('توصيل')) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFFEF3C7),
        textColor: const Color(0xFFB45309),
      );
    }

    // 4. Processing / Preparing
    if (status.contains('prep') ||
        status == 'processing' ||
        label.contains('تجهيز')) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFEEF2FF),
        textColor: const Color(0xFF4F46E5),
      );
    }

    // 5. Transfer / Review / Pending
    if (status.contains('transfer') ||
        status.contains('pending') ||
        label.contains('حوالة') ||
        label.contains('تأكيد')) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFFEF3C7),
        textColor: AppColors.warningAlert,
      );
    }

    return _StatusStyle(
      backgroundColor: const Color(0xFFEEF2FF),
      textColor: const Color(0xFF3B82F6),
    );
  }

  _StatusStyle _getPaymentStatusStyle(OrderResponseEntity order) {
    final status = order.paymentStatus.toLowerCase();
    final label = order.paymentStatusLabel;

    if (status.contains('fail') ||
        status.contains('cancel') ||
        status == 'unpaid' ||
        status == 'rejected' ||
        status.contains('reject') ||
        label.contains('فشل') ||
        label.contains('ملغ') ||
        label.contains('إلغاء') ||
        label.contains('مرفوض') ||
        label.contains('غير')) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFFEE2E2),
        textColor: const Color(0xFFDC2626),
      );
    } else if (status == 'paid' ||
        status == 'completed' ||
        label.contains('تم الدفع') ||
        label.contains('مدفوع') ||
        label.contains('مكتمل')) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFD1FAE5),
        textColor: const Color(0xFF059669),
      );
    } else if (order.needsPaymentReview ||
        status.contains('review') ||
        status == 'pending' ||
        label.contains('مراجعة') ||
        label.contains('انتظار') ||
        label.contains('تأكيد')) {
      return _StatusStyle(
        backgroundColor: const Color(0xFFFEF3C7),
        textColor: AppColors.warningAlert,
      );
    }

    return _StatusStyle(
      backgroundColor: const Color(0xFFF3F4F6),
      textColor: const Color(0xFF6B7280),
    );
  }

  String _getActionLabel(OrderResponseEntity order) {
    return OrderLocalizationHelper.getActionLabel(order);
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
