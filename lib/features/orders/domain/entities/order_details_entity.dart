import 'package:equatable/equatable.dart';
import 'package:spenza/features/orders/domain/entities/order_delivery_address_entity.dart';
import 'package:spenza/features/orders/domain/entities/order_delivery_entity.dart';
import 'package:spenza/features/orders/domain/entities/order_item_entity.dart';
import 'package:spenza/features/orders/domain/entities/order_totals_entity.dart';
import 'package:spenza/features/orders/domain/entities/order_tracking_entity.dart';

class OrderDetailsEntity extends Equatable {
  final int id;
  final String orderNumber;
  final String customerName;
  final String customerPhone;
  final String cityName;
  final String countryName;
  final int itemsCount;
  final num total;
  final String paymentMethod;
  final String paymentMethodLabel;
  final String paymentStatus;
  final String paymentStatusLabel;
  final bool needsPaymentReview;
  final String status;
  final String statusLabel;
  final String deliveryMethodLabel;
  final OrderTrackingEntity? tracking;
  final bool isCompleted;
  final bool canBeCancelled;
  final String placedAt;
  final String? createdAt;
  final String address;
  final OrderDeliveryAddressEntity? deliveryAddress;
  final OrderDeliveryEntity? delivery;
  final OrderTotalsEntity? totals;
  final List<OrderItemEntity> items;

  const OrderDetailsEntity({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.cityName,
    required this.countryName,
    required this.itemsCount,
    required this.total,
    required this.paymentMethod,
    required this.paymentMethodLabel,
    required this.paymentStatus,
    required this.paymentStatusLabel,
    required this.needsPaymentReview,
    required this.status,
    required this.statusLabel,
    required this.deliveryMethodLabel,
    this.tracking,
    required this.isCompleted,
    required this.canBeCancelled,
    required this.placedAt,
    this.createdAt,
    required this.address,
    this.deliveryAddress,
    this.delivery,
    this.totals,
    this.items = const [],
  });

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        customerName,
        customerPhone,
        cityName,
        countryName,
        itemsCount,
        total,
        paymentMethod,
        paymentMethodLabel,
        paymentStatus,
        paymentStatusLabel,
        needsPaymentReview,
        status,
        statusLabel,
        deliveryMethodLabel,
        tracking,
        isCompleted,
        canBeCancelled,
        placedAt,
        createdAt,
        address,
        deliveryAddress,
        delivery,
        totals,
        items,
      ];
}
