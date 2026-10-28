import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';
import 'package:spenza/features/orders/presentation/widgets/order_help_bottom_sheet.dart';

abstract class OrderLocalizationHelper {
  /// Returns the localized label for the primary action button on an Order Card
  static String getActionLabel(OrderResponseEntity order) {
    final label = order.statusLabel;
    final status = order.status.toLowerCase();

    if (status.contains('cancel') ||
        label.contains('ملغ') ||
        label.contains('إلغاء')) {
      return 'order_details'.tr();
    } else if (label.contains('حوالة') ||
        order.needsPaymentReview ||
        label.contains('دفعه')) {
      return 'payment_status'.tr();
    } else if (label.contains('مندوب') || label.contains('توصيل')) {
      return 'track_order'.tr();
    }
    return 'order_details'.tr();
  }

  /// Formats order date to a localized string (Today, Yesterday, or formatted date)
  static String formatDate(String dateStr, {bool includeTime = false, BuildContext? context}) {
    if (dateStr.isEmpty) return 'today'.tr();
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final itemDate = DateTime(dt.year, dt.month, dt.day);

      String timeStr = '';
      if (includeTime && context != null) {
        final isAr = context.locale.languageCode == 'ar';
        final formattedTime = DateFormat('h:mm a').format(dt);
        timeStr = ' ${isAr ? formattedTime.replaceAll('AM', 'ص').replaceAll('PM', 'م') : formattedTime}';
      }

      if (itemDate == today) {
        return '${'today'.tr()}$timeStr';
      } else if (itemDate == yesterday) {
        return '${'yesterday'.tr()}$timeStr';
      } else {
        return '${DateFormat('yyyy/MM/dd').format(dt)}$timeStr';
      }
    } catch (_) {
      return 'today'.tr();
    }
  }

  /// Returns localized WhatsApp help message template for support options
  static String getWhatsAppHelpMessage(
    OrderHelpType type,
    String orderNumber, {
    bool isArabic = true,
  }) {
    if (isArabic) {
      return switch (type) {
        OrderHelpType.cancel =>
          'مرحبا سبينزا 🌷\nبدي ألغي طلبي رقم $orderNumber، بتشوفولي إذا لسا بيتلغى؟ يعطيكن العافية.\nسبب الإلغاء: ',
        OrderHelpType.products =>
          'مرحبا سبينزا 🌷\nعندي مشكلة بطلبي رقم $orderNumber، وبقدر أبعتلكن صورة إذا بدكن. يعطيكن العافية.\nالمنتج والمشكلة: ',
        OrderHelpType.payment =>
          'مرحبا سبينزا 🌷\nبدي أسأل عن الدفع بطلبي رقم $orderNumber. يعطيكن العافية.\nسؤالي: ',
        OrderHelpType.chat =>
          'مرحبا سبينزا 🌷\nبخصوص طلبي رقم $orderNumber. يعطيكن العافية.\nبدي احكيلكن عن: ',
      };
    } else {
      return switch (type) {
        OrderHelpType.cancel =>
          'Hello Spenza 🌷\nI would like to cancel my order #$orderNumber. Could you please check if it can still be cancelled? Thank you.\nReason for cancellation: ',
        OrderHelpType.products =>
          'Hello Spenza 🌷\nI have an issue with my order #$orderNumber, and I can send a photo if needed. Thank you.\nProduct & Issue: ',
        OrderHelpType.payment =>
          'Hello Spenza 🌷\nI have a question about payment for my order #$orderNumber. Thank you.\nMy question: ',
        OrderHelpType.chat =>
          'Hello Spenza 🌷\nRegarding my order #$orderNumber. Thank you.\nI would like to talk about: ',
      };
    }
  }
}
