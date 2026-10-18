import 'package:equatable/equatable.dart';

class DeliveryOptionEntity extends Equatable {
  final String method;
  final String methodLabel;
  final String description;
  final num fee;
  final num baseFee;
  final num surcharge;
  final num waived;
  final bool isFree;
  final int etaHours;
  final String etaLabel;
  final bool isAvailable;
  final String? unavailableReason;

  const DeliveryOptionEntity({
    required this.method,
    required this.methodLabel,
    required this.description,
    required this.fee,
    required this.baseFee,
    required this.surcharge,
    required this.waived,
    required this.isFree,
    required this.etaHours,
    required this.etaLabel,
    required this.isAvailable,
    this.unavailableReason,
  });

  @override
  List<Object?> get props => [
        method,
        methodLabel,
        description,
        fee,
        baseFee,
        surcharge,
        waived,
        isFree,
        etaHours,
        etaLabel,
        isAvailable,
        unavailableReason,
      ];
}

class PaymentMethodOptionEntity extends Equatable {
  final String key;
  final String label;
  final bool enabled;

  const PaymentMethodOptionEntity({
    required this.key,
    required this.label,
    required this.enabled,
  });

  @override
  List<Object?> get props => [key, label, enabled];
}

class CheckoutOptionsEntity extends Equatable {
  final num deliveryFee;
  final List<DeliveryOptionEntity> deliveryOptions;
  final String currency;
  final String paymentZone;
  final String paymentZoneLabel;
  final List<PaymentMethodOptionEntity> paymentMethods;
  final bool isAvailable;
  final String? message;

  const CheckoutOptionsEntity({
    required this.deliveryFee,
    required this.deliveryOptions,
    required this.currency,
    required this.paymentZone,
    required this.paymentZoneLabel,
    required this.paymentMethods,
    required this.isAvailable,
    this.message,
  });

  @override
  List<Object?> get props => [
        deliveryFee,
        deliveryOptions,
        currency,
        paymentZone,
        paymentZoneLabel,
        paymentMethods,
        isAvailable,
        message,
      ];
}
