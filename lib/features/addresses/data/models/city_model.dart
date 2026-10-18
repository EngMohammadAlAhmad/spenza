import 'package:spenza/features/addresses/domain/entities/city_entity.dart';

class CityModel extends CityEntity {
  const CityModel({
    required super.id,
    required super.name,
    super.deliveryPrice = 0,
    super.expressDeliveryPrice,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] is num
          ? (json['id'] as num).toInt()
          : (int.tryParse(json['id']?.toString() ?? '') ?? 0),
      name: json['name']?.toString() ?? '',
      deliveryPrice: json['delivery_price'] is num
          ? json['delivery_price'] as num
          : (num.tryParse(json['delivery_price']?.toString() ?? '') ?? 0),
      expressDeliveryPrice: json['express_delivery_price'] is num
          ? json['express_delivery_price'] as num
          : num.tryParse(json['express_delivery_price']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'delivery_price': deliveryPrice,
        'express_delivery_price': expressDeliveryPrice,
      };
}
