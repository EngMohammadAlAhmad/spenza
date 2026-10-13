import 'package:equatable/equatable.dart';
import 'package:spenza/features/orders/domain/entities/order_tracking_entity.dart';

class OrderResponseEntity extends Equatable {
  final int id;
  final String orderNumber;
  final String customerName;
  final String customerPhone;
  final String cityName;
  final String countryName;
  final int itemsCount;
  final num totalAmount;
  final String currency;
  final String paymentMethod;
  final String paymentMethodLabel;
  final String paymentStatus;
  final String paymentStatusLabel;
  final bool needsPaymentReview;
  final String status;
  final String statusLabel;
  final String deliveryMethod;
  final String deliveryMethodLabel;
  final OrderTrackingEntity? tracking;
  final List<String> itemImages;
  final bool isCompleted;
  final bool canBeCancelled;
  final String placedAt;
  final String? createdAt;
  final int pointsEarned;
  final String deliveryAddress;
  final String expectedDelivery;

  const OrderResponseEntity({
    required this.id,
    required this.orderNumber,
    this.customerName = '',
    this.customerPhone = '',
    this.cityName = '',
    this.countryName = '',
    this.itemsCount = 1,
    required this.totalAmount,
    this.currency = 'USD',
    required this.paymentMethod,
    required this.paymentMethodLabel,
    this.paymentStatus = 'pending',
    this.paymentStatusLabel = 'قيد الانتظار',
    this.needsPaymentReview = false,
    required this.status,
    required this.statusLabel,
    this.deliveryMethod = 'standard',
    this.deliveryMethodLabel = 'توصيل عادي',
    this.tracking,
    this.itemImages = const [],
    this.isCompleted = false,
    this.canBeCancelled = false,
    this.placedAt = '',
    this.createdAt,
    this.pointsEarned = 0,
    this.deliveryAddress = 'المنزل',
    this.expectedDelivery = 'خلال 48 ساعة',
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
        totalAmount,
        currency,
        paymentMethod,
        paymentMethodLabel,
        paymentStatus,
        paymentStatusLabel,
        needsPaymentReview,
        status,
        statusLabel,
        deliveryMethod,
        deliveryMethodLabel,
        tracking,
        itemImages,
        isCompleted,
        canBeCancelled,
        placedAt,
        createdAt,
        pointsEarned,
        deliveryAddress,
        expectedDelivery,
      ];
}
