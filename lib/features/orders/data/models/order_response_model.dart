import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';

class OrderResponseModel extends OrderResponseEntity {
  const OrderResponseModel({
    required super.id,
    required super.orderNumber,
    required super.status,
    required super.statusLabel,
    required super.paymentMethod,
    required super.paymentMethodLabel,
    required super.totalAmount,
    required super.pointsEarned,
    required super.deliveryAddress,
    required super.expectedDelivery,
    super.createdAt,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final parsedId = rawId is num
        ? rawId.toInt()
        : (int.tryParse(rawId?.toString() ?? '') ?? 0);

    final rawTotal = json['total_amount'] ?? json['total'] ?? json['grand_total'];
    final parsedTotal = rawTotal is num
        ? rawTotal
        : (num.tryParse(rawTotal?.toString() ?? '') ?? 0);

    final rawPoints = json['points_earned'] ?? json['points'] ?? json['earned_points'];
    final parsedPoints = rawPoints is num
        ? rawPoints.toInt()
        : (int.tryParse(rawPoints?.toString() ?? '') ?? 0);

    final addressVal = json['delivery_address'] ?? json['address'] ?? json['user_address'];
    final parsedAddress = _parseAddress(addressVal);

    return OrderResponseModel(
      id: parsedId,
      orderNumber: json['order_number']?.toString() ??
          json['order_code']?.toString() ??
          json['code']?.toString() ??
          (parsedId > 0 ? 'SPZ-$parsedId' : 'SPZ-80329'),
      status: json['status']?.toString() ?? 'received',
      statusLabel: json['status_label']?.toString() ??
          json['status_text']?.toString() ??
          'تم استلام الطلب',
      paymentMethod: json['payment_method']?.toString() ?? 'cash_on_delivery',
      paymentMethodLabel: json['payment_method_label']?.toString() ??
          'بتدفع عند الاستلام',
      totalAmount: parsedTotal,
      pointsEarned: parsedPoints,
      deliveryAddress: parsedAddress.isNotEmpty ? parsedAddress : 'المنزل',
      expectedDelivery: json['expected_delivery']?.toString() ?? 'خلال 48 ساعة',
      createdAt: json['created_at']?.toString(),
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
        'status': status,
        'status_label': statusLabel,
        'payment_method': paymentMethod,
        'payment_method_label': paymentMethodLabel,
        'total_amount': totalAmount,
        'points_earned': pointsEarned,
        'delivery_address': deliveryAddress,
        'expected_delivery': expectedDelivery,
        'created_at': createdAt,
      };
}
