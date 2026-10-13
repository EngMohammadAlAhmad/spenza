import 'package:equatable/equatable.dart';

class OrderResponseEntity extends Equatable {
  final int id;
  final String orderNumber;
  final String status;
  final String statusLabel;
  final String paymentMethod;
  final String paymentMethodLabel;
  final num totalAmount;
  final int pointsEarned;
  final String deliveryAddress;
  final String expectedDelivery;
  final String? createdAt;

  const OrderResponseEntity({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.statusLabel,
    required this.paymentMethod,
    required this.paymentMethodLabel,
    required this.totalAmount,
    required this.pointsEarned,
    required this.deliveryAddress,
    required this.expectedDelivery,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        status,
        statusLabel,
        paymentMethod,
        paymentMethodLabel,
        totalAmount,
        pointsEarned,
        deliveryAddress,
        expectedDelivery,
        createdAt,
      ];
}
