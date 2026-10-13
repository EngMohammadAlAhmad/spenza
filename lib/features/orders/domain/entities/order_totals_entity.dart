import 'package:equatable/equatable.dart';

class OrderTotalsEntity extends Equatable {
  final num itemsSubtotal;
  final num discountTotal;
  final num deliveryFee;
  final num total;

  const OrderTotalsEntity({
    required this.itemsSubtotal,
    required this.discountTotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  List<Object?> get props => [
        itemsSubtotal,
        discountTotal,
        deliveryFee,
        total,
      ];
}
