import 'package:spenza/features/orders/data/models/order_delivery_address_model.dart';
import 'package:spenza/features/orders/data/models/order_delivery_model.dart';
import 'package:spenza/features/orders/data/models/order_item_model.dart';
import 'package:spenza/features/orders/data/models/order_totals_model.dart';
import 'package:spenza/features/orders/data/models/order_tracking_model.dart';
import 'package:spenza/features/orders/domain/entities/order_details_entity.dart';

class OrderDetailsModel extends OrderDetailsEntity {
  const OrderDetailsModel({
    required super.id,
    required super.orderNumber,
    required super.customerName,
    required super.customerPhone,
    required super.cityName,
    required super.countryName,
    required super.itemsCount,
    required super.total,
    required super.paymentMethod,
    required super.paymentMethodLabel,
    required super.paymentStatus,
    required super.paymentStatusLabel,
    required super.needsPaymentReview,
    required super.status,
    required super.statusLabel,
    required super.deliveryMethodLabel,
    super.tracking,
    required super.isCompleted,
    required super.canBeCancelled,
    super.canUploadReceipt = false,
    super.rejectionReason,
    required super.placedAt,
    super.createdAt,
    required super.address,
    super.deliveryAddress,
    super.delivery,
    super.totals,
    super.items = const [],
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = json;
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      data = json['data'] as Map<String, dynamic>;
    }

    OrderTrackingModel? trackingModel;
    if (data['tracking'] is Map<String, dynamic>) {
      trackingModel = OrderTrackingModel.fromJson(data['tracking'] as Map<String, dynamic>);
    }

    OrderDeliveryAddressModel? deliveryAddressModel;
    if (data['delivery_address'] is Map<String, dynamic>) {
      deliveryAddressModel = OrderDeliveryAddressModel.fromJson(data['delivery_address'] as Map<String, dynamic>);
    }

    OrderDeliveryModel? deliveryModel;
    if (data['delivery'] is Map<String, dynamic>) {
      deliveryModel = OrderDeliveryModel.fromJson(data['delivery'] as Map<String, dynamic>);
    }

    OrderTotalsModel? totalsModel;
    if (data['totals'] is Map<String, dynamic>) {
      totalsModel = OrderTotalsModel.fromJson(data['totals'] as Map<String, dynamic>);
    }

    List<OrderItemModel> parsedItems = [];
    if (data['items'] is List) {
      parsedItems = (data['items'] as List)
          .whereType<Map<String, dynamic>>()
          .map((itemJson) => OrderItemModel.fromJson(itemJson))
          .toList();
    }

    String? rejectionReason;
    if (data['rejection_reason'] != null && data['rejection_reason'].toString().isNotEmpty) {
      rejectionReason = data['rejection_reason'].toString();
    } else if (data['receipts'] is List && (data['receipts'] as List).isNotEmpty) {
      final receiptsList = data['receipts'] as List;
      for (var r in receiptsList.reversed) {
        if (r is Map<String, dynamic>) {
          if (r['rejection_reason'] != null && r['rejection_reason'].toString().isNotEmpty) {
            rejectionReason = r['rejection_reason'].toString();
            break;
          } else if (r['note'] != null && r['note'].toString().isNotEmpty && r['status'] == 'rejected') {
            rejectionReason = r['note'].toString();
            break;
          }
        }
      }
    }

    return OrderDetailsModel(
      id: _parseInt(data['id']),
      orderNumber: data['order_number']?.toString() ?? '',
      customerName: data['customer_name']?.toString() ?? '',
      customerPhone: data['customer_phone']?.toString() ?? '',
      cityName: data['city_name']?.toString() ?? '',
      countryName: data['country_name']?.toString() ?? '',
      itemsCount: _parseInt(data['items_count']),
      total: _parseNum(data['total']),
      paymentMethod: data['payment_method']?.toString() ?? '',
      paymentMethodLabel: data['payment_method_label']?.toString() ?? '',
      paymentStatus: data['payment_status']?.toString() ?? '',
      paymentStatusLabel: data['payment_status_label']?.toString() ?? '',
      needsPaymentReview: data['needs_payment_review'] == true,
      status: data['status']?.toString() ?? '',
      statusLabel: data['status_label']?.toString() ?? '',
      deliveryMethodLabel: data['delivery_method_label']?.toString() ?? '',
      tracking: trackingModel,
      isCompleted: data['is_completed'] == true,
      canBeCancelled: data['can_be_cancelled'] == true,
      canUploadReceipt: data['can_upload_receipt'] == true,
      rejectionReason: rejectionReason,
      placedAt: data['placed_at']?.toString() ?? '',
      createdAt: data['created_at']?.toString(),
      address: data['address']?.toString() ?? '',
      deliveryAddress: deliveryAddressModel,
      delivery: deliveryModel,
      totals: totalsModel,
      items: parsedItems,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static num _parseNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? 0;
    return 0;
  }
}
