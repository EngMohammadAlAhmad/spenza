import 'package:spenza/features/addresses/data/models/city_model.dart';
import 'package:spenza/features/addresses/domain/entities/governorate_entity.dart';

class GovernorateModel extends GovernorateEntity {
  const GovernorateModel({
    required super.id,
    required super.name,
    super.supportsExpressDelivery = false,
    super.expressDeliverySurcharge = 0,
    super.cities = const [],
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    List<CityModel> parsedCities = [];
    if (json['cities'] is List) {
      parsedCities = (json['cities'] as List)
          .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return GovernorateModel(
      id: json['id'] is num
          ? (json['id'] as num).toInt()
          : (int.tryParse(json['id']?.toString() ?? '') ?? 0),
      name: json['name']?.toString() ?? '',
      supportsExpressDelivery: json['supports_express_delivery'] == true,
      expressDeliverySurcharge: json['express_delivery_surcharge'] is num
          ? json['express_delivery_surcharge'] as num
          : (num.tryParse(json['express_delivery_surcharge']?.toString() ?? '') ?? 0),
      cities: parsedCities,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'supports_express_delivery': supportsExpressDelivery,
        'express_delivery_surcharge': expressDeliverySurcharge,
        'cities': (cities as List<CityModel>).map((c) => c.toJson()).toList(),
      };
}
