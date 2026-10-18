import 'package:spenza/features/orders/data/models/order_tracking_model.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';

class OrderResponseModel extends OrderResponseEntity {
  const OrderResponseModel({
    required super.id,
    required super.orderNumber,
    super.customerName = '',
    super.customerPhone = '',
    super.cityName = '',
    super.countryName = '',
    super.itemsCount = 1,
    required super.totalAmount,
    super.currency = 'USD',
    required super.paymentMethod,
    required super.paymentMethodLabel,
    super.paymentStatus = 'pending',
    super.paymentStatusLabel = 'قيد الانتظار',
    super.needsPaymentReview = false,
    required super.status,
    required super.statusLabel,
    super.deliveryMethod = 'standard',
    super.deliveryMethodLabel = 'توصيل عادي',
    super.tracking,
    super.itemImages = const [],
    super.isCompleted = false,
    super.canBeCancelled = false,
    super.placedAt = '',
    super.createdAt,
    super.pointsEarned = 0,
    super.deliveryAddress = 'المنزل',
    super.expectedDelivery = 'خلال 48 ساعة',
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final parsedId = rawId is num
        ? rawId.toInt()
        : (int.tryParse(rawId?.toString() ?? '') ?? 0);

    final rawTotal = json['total'] ?? json['total_amount'] ?? json['grand_total'];
    final parsedTotal = rawTotal is num
        ? rawTotal
        : (num.tryParse(rawTotal?.toString() ?? '') ?? 0);

    final rawPoints = json['points_earned'] ?? json['points'] ?? json['earned_points'];
    final parsedPoints = rawPoints is num
        ? rawPoints.toInt()
        : (int.tryParse(rawPoints?.toString() ?? '') ?? 0);

    final rawItemsCount = json['items_count'] ?? json['item_count'];
    final parsedItemsCount = rawItemsCount is num
        ? rawItemsCount.toInt()
        : (int.tryParse(rawItemsCount?.toString() ?? '') ?? 1);

    final addressVal = json['delivery_address'] ?? json['address'] ?? json['user_address'];
    final parsedAddress = _parseAddress(addressVal);

    List<String> images = [];
    if (json['items'] is List) {
      for (var item in json['items']) {
        if (item is String && item.isNotEmpty) {
          images.add(item);
        } else if (item is Map) {
          final imgUrl = item['image'] ??
              item['thumb'] ??
              item['product_image'] ??
              item['main_image'] ??
              item['photo'] ??
              item['product']?['image'] ??
              item['product']?['main_image'];
          if (imgUrl != null && imgUrl.toString().isNotEmpty) {
            images.add(imgUrl.toString());
          }
        }
      }
    }

    OrderTrackingModel? parsedTracking;
    if (json['tracking'] is Map<String, dynamic>) {
      parsedTracking = OrderTrackingModel.fromJson(json['tracking'] as Map<String, dynamic>);
    }

    return OrderResponseModel(
      id: parsedId,
      orderNumber: json['order_number']?.toString() ??
          json['order_code']?.toString() ??
          json['code']?.toString() ??
          (parsedId > 0 ? 'SPZ-$parsedId' : ''),
      customerName: json['customer_name']?.toString() ?? '',
      customerPhone: json['customer_phone']?.toString() ?? '',
      cityName: json['city_name']?.toString() ?? '',
      countryName: json['country_name']?.toString() ?? '',
      itemsCount: parsedItemsCount,
      totalAmount: parsedTotal,
      currency: json['currency']?.toString() ?? 'USD',
      paymentMethod: json['payment_method']?.toString() ?? 'cash_on_delivery',
      paymentMethodLabel: json['payment_method_label']?.toString() ?? 'الدفع عند الاستلام',
      paymentStatus: json['payment_status']?.toString() ?? 'pending',
      paymentStatusLabel: json['payment_status_label']?.toString() ?? 'قيد الانتظار',
      needsPaymentReview: json['needs_payment_review'] == true,
      status: json['status']?.toString() ?? 'pending',
      statusLabel: json['status_label']?.toString() ??
          json['status_text']?.toString() ??
          'قيد الانتظار',
      deliveryMethod: json['delivery_method']?.toString() ?? 'standard',
      deliveryMethodLabel: json['delivery_method_label']?.toString() ?? 'توصيل عادي',
      tracking: parsedTracking,
      itemImages: images,
      isCompleted: json['is_completed'] == true,
      canBeCancelled: json['can_be_cancelled'] == true,
      placedAt: json['placed_at']?.toString() ?? json['created_at']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
      pointsEarned: parsedPoints,
      deliveryAddress: parsedAddress.isNotEmpty ? parsedAddress : 'المنزل',
      expectedDelivery: json['expected_delivery']?.toString() ?? 'خلال 48 ساعة',
    );
  }

  static String _parseAddress(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Map) {
      final title = value['title']?.toString() ??
          value['name']?.toString() ??
          value['label']?.toString();
      final address = value['address']?.toString() ??
          value['details']?.toString() ??
          value['street']?.toString() ??
          value['formatted_address']?.toString() ??
          value['city']?.toString();

      if (title != null && title.isNotEmpty && address != null && address.isNotEmpty) {
        return '$title • $address';
      }
      return address ?? title ?? '';
    }
    return value.toString();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_number': orderNumber,
        'customer_name': customerName,
        'customer_phone': customerPhone,
        'city_name': cityName,
        'country_name': countryName,
        'items_count': itemsCount,
        'total': totalAmount,
        'currency': currency,
        'payment_method': paymentMethod,
        'payment_method_label': paymentMethodLabel,
        'payment_status': paymentStatus,
        'payment_status_label': paymentStatusLabel,
        'needs_payment_review': needsPaymentReview,
        'status': status,
        'status_label': statusLabel,
        'delivery_method': deliveryMethod,
        'delivery_method_label': deliveryMethodLabel,
        'is_completed': isCompleted,
        'can_be_cancelled': canBeCancelled,
        'placed_at': placedAt,
        'created_at': createdAt,
        'points_earned': pointsEarned,
        'delivery_address': deliveryAddress,
        'expected_delivery': expectedDelivery,
      };
}
