import 'package:spenza/features/addresses/domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.type,
    required super.typeLabel,
    required super.label,
    required super.displayLabel,
    required super.countryId,
    required super.countryName,
    required super.cityId,
    required super.cityName,
    required super.area,
    required super.street,
    required super.building,
    required super.floor,
    required super.phone,
    required super.line,
    required super.isDefault,
    super.createdAt,
    super.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int? ?? 0,
      type: json['type'] as String? ?? 'home',
      typeLabel: json['type_label'] as String? ?? json['type'] as String? ?? '',
      label: json['label'] as String? ?? '',
      displayLabel: json['display_label'] as String? ?? json['label'] as String? ?? '',
      countryId: json['country_id'] as int? ?? 0,
      countryName: json['country_name'] as String? ?? '',
      cityId: json['city_id'] as int? ?? 0,
      cityName: json['city_name'] as String? ?? '',
      area: json['area'] as String? ?? '',
      street: json['street'] as String? ?? '',
      building: json['building'] as String? ?? '',
      floor: json['floor'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      line: json['line'] as String? ?? '',
      isDefault: json['is_default'] as bool? ?? (json['is_default'] == 1),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'type_label': typeLabel,
        'label': label,
        'display_label': displayLabel,
        'country_id': countryId,
        'country_name': countryName,
        'city_id': cityId,
        'city_name': cityName,
        'area': area,
        'street': street,
        'building': building,
        'floor': floor,
        'phone': phone,
        'line': line,
        'is_default': isDefault,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
