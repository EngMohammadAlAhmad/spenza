import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final int id;
  final String name;
  final num deliveryPrice;
  final num? expressDeliveryPrice;

  const CityEntity({
    required this.id,
    required this.name,
    this.deliveryPrice = 0,
    this.expressDeliveryPrice,
  });

  @override
  List<Object?> get props => [id, name, deliveryPrice, expressDeliveryPrice];
}
