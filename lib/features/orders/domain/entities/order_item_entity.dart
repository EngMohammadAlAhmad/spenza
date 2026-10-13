import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final int id;
  final int productId;
  final String productName;
  final String unitName;
  final String variantLabel;
  final String? productImage;
  final num unitPrice;
  final int quantity;
  final num lineTotal;

  const OrderItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.unitName,
    required this.variantLabel,
    this.productImage,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        unitName,
        variantLabel,
        productImage,
        unitPrice,
        quantity,
        lineTotal,
      ];
}
