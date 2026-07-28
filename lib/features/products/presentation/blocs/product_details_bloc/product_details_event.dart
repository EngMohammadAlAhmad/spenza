part of 'product_details_bloc.dart';

sealed class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetProductDetailsEvent extends ProductDetailsEvent {
  final int productId;

  const GetProductDetailsEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class SelectUnitEvent extends ProductDetailsEvent {
  final int unitId;
  const SelectUnitEvent(this.unitId);

  @override
  List<Object?> get props => [unitId];
}

class SelectVariantOptionEvent extends ProductDetailsEvent {
  final int attributeId;
  final int valueId;
  const SelectVariantOptionEvent({required this.attributeId, required this.valueId});

  @override
  List<Object?> get props => [attributeId, valueId];
}

class UpdateQuantityEvent extends ProductDetailsEvent {
  final int delta;
  const UpdateQuantityEvent(this.delta);

  @override
  List<Object?> get props => [delta];
}
