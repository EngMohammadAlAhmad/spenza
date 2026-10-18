import 'package:spenza/features/cart/domain/entities/checkout_options_entity.dart';

class DeliveryOptionModel extends DeliveryOptionEntity {
  const DeliveryOptionModel({
    required super.method,
    required super.methodLabel,
    required super.description,
    required super.fee,
    required super.baseFee,
    required super.surcharge,
    required super.waived,
    required super.isFree,
    required super.etaHours,
    required super.etaLabel,
    required super.isAvailable,
    super.unavailableReason,
  });

  factory DeliveryOptionModel.fromJson(Map<String, dynamic> json) {
    return DeliveryOptionModel(
      method: json['method']?.toString() ?? '',
      methodLabel: json['method_label']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      fee: json['fee'] is num
          ? json['fee'] as num
          : (num.tryParse(json['fee']?.toString() ?? '') ?? 0),
      baseFee: json['base_fee'] is num
          ? json['base_fee'] as num
          : (num.tryParse(json['base_fee']?.toString() ?? '') ?? 0),
      surcharge: json['surcharge'] is num
          ? json['surcharge'] as num
          : (num.tryParse(json['surcharge']?.toString() ?? '') ?? 0),
      waived: json['waived'] is num
          ? json['waived'] as num
          : (num.tryParse(json['waived']?.toString() ?? '') ?? 0),
      isFree: json['is_free'] == true,
      etaHours: json['eta_hours'] is num
          ? (json['eta_hours'] as num).toInt()
          : (int.tryParse(json['eta_hours']?.toString() ?? '') ?? 0),
      etaLabel: json['eta_label']?.toString() ?? '',
      isAvailable: json['is_available'] == true,
      unavailableReason: json['unavailable_reason']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'method': method,
        'method_label': methodLabel,
        'description': description,
        'fee': fee,
        'base_fee': baseFee,
        'surcharge': surcharge,
        'waived': waived,
        'is_free': isFree,
        'eta_hours': etaHours,
        'eta_label': etaLabel,
        'is_available': isAvailable,
        'unavailable_reason': unavailableReason,
      };
}

class PaymentMethodOptionModel extends PaymentMethodOptionEntity {
  const PaymentMethodOptionModel({
    required super.key,
    required super.label,
    required super.enabled,
  });

  factory PaymentMethodOptionModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodOptionModel(
      key: json['key']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      enabled: json['enabled'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'label': label,
        'enabled': enabled,
      };
}

class CheckoutOptionsModel extends CheckoutOptionsEntity {
  const CheckoutOptionsModel({
    required super.deliveryFee,
    required super.deliveryOptions,
    required super.currency,
    required super.paymentZone,
    required super.paymentZoneLabel,
    required super.paymentMethods,
    required super.isAvailable,
    super.message,
  });

  factory CheckoutOptionsModel.fromJson(Map<String, dynamic> json) {
    List<DeliveryOptionModel> parsedDeliveryOptions = [];
    if (json['delivery_options'] is List) {
      parsedDeliveryOptions = (json['delivery_options'] as List)
          .map((e) => DeliveryOptionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<PaymentMethodOptionModel> parsedPaymentMethods = [];
    if (json['payment_methods'] is List) {
      parsedPaymentMethods = (json['payment_methods'] as List)
          .map((e) => PaymentMethodOptionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return CheckoutOptionsModel(
      deliveryFee: json['delivery_fee'] is num
          ? json['delivery_fee'] as num
          : (num.tryParse(json['delivery_fee']?.toString() ?? '') ?? 0),
      deliveryOptions: parsedDeliveryOptions,
      currency: json['currency']?.toString() ?? 'USD',
      paymentZone: json['payment_zone']?.toString() ?? '',
      paymentZoneLabel: json['payment_zone_label']?.toString() ?? '',
      paymentMethods: parsedPaymentMethods,
      isAvailable: json['is_available'] == true,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'delivery_fee': deliveryFee,
        'delivery_options':
            (deliveryOptions as List<DeliveryOptionModel>).map((e) => e.toJson()).toList(),
        'currency': currency,
        'payment_zone': paymentZone,
        'payment_zone_label': paymentZoneLabel,
        'payment_methods':
            (paymentMethods as List<PaymentMethodOptionModel>).map((e) => e.toJson()).toList(),
        'is_available': isAvailable,
        'message': message,
      };
}
