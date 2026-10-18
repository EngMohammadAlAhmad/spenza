import 'package:equatable/equatable.dart';
import 'package:spenza/features/addresses/domain/entities/city_entity.dart';

class GovernorateEntity extends Equatable {
  final int id;
  final String name;
  final bool supportsExpressDelivery;
  final num expressDeliverySurcharge;
  final List<CityEntity> cities;

  const GovernorateEntity({
    required this.id,
    required this.name,
    this.supportsExpressDelivery = false,
    this.expressDeliverySurcharge = 0,
    this.cities = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        supportsExpressDelivery,
        expressDeliverySurcharge,
        cities,
      ];
}
