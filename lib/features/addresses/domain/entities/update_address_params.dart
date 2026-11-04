import 'package:equatable/equatable.dart';

class UpdateAddressParams extends Equatable {
  final int addressId;
  final String type;
  final String label;
  final int cityId;
  final String area;
  final String street;
  final String building;
  final String floor;
  final String phone;
  final bool isDefault;

  const UpdateAddressParams({
    required this.addressId,
    required this.type,
    required this.label,
    required this.cityId,
    required this.area,
    required this.street,
    required this.building,
    required this.floor,
    required this.phone,
    required this.isDefault,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'label': label,
        'city_id': cityId,
        'area': area,
        'street': street,
        'building': building,
        'floor': floor,
        'phone': phone,
        'is_default': isDefault,
      };

  @override
  List<Object?> get props => [
        addressId,
        type,
        label,
        cityId,
        area,
        street,
        building,
        floor,
        phone,
        isDefault,
      ];
}
