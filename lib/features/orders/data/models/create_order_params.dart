import 'package:equatable/equatable.dart';

class CreateOrderParams extends Equatable {
  final int addressId;
  final String deliveryMethod; // 'standard', 'express'
  final String? notes;
  final String paymentMethod; // 'cash_on_delivery', etc.
  final List<CreateOrderItemParams> items;

  const CreateOrderParams({
    required this.addressId,
    required this.deliveryMethod,
    this.notes,
    required this.paymentMethod,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'address_id': addressId,
        'delivery_method': deliveryMethod,
        if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
        'payment_method': paymentMethod,
        'items': items.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        addressId,
        deliveryMethod,
        notes,
        paymentMethod,
        items,
      ];
}

class CreateOrderItemParams extends Equatable {
  final int productId;
  final int productUnitId;
  final int? productVariantId;
  final int quantity;

  const CreateOrderItemParams({
    required this.productId,
    required this.productUnitId,
    this.productVariantId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_unit_id': productUnitId,
        if (productVariantId != null) 'product_variant_id': productVariantId,
        'quantity': quantity,
      };

  @override
  List<Object?> get props => [
        productId,
        productUnitId,
        productVariantId,
        quantity,
      ];
}
