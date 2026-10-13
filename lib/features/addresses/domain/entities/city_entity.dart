import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final int id;
  final String name;

  const CityEntity({
    required this.id,
    required this.name,
  });

  static const List<CityEntity> defaultCities = [
    CityEntity(id: 1, name: 'دمشق'),
    CityEntity(id: 2, name: 'ريف دمشق'),
    CityEntity(id: 3, name: 'حلب'),
    CityEntity(id: 4, name: 'حمص'),
    CityEntity(id: 5, name: 'اللاذقية'),
    CityEntity(id: 6, name: 'طرطوس'),
    CityEntity(id: 7, name: 'حماة'),
  ];

  @override
  List<Object?> get props => [id, name];
}
