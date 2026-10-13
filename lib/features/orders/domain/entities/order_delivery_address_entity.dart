import 'package:equatable/equatable.dart';

class OrderDeliveryAddressEntity extends Equatable {
  final String label;
  final String countryName;
  final String cityName;
  final String area;
  final String line;
  final String phone;

  const OrderDeliveryAddressEntity({
    required this.label,
    required this.countryName,
    required this.cityName,
    required this.area,
    required this.line,
    required this.phone,
  });

  @override
  List<Object?> get props => [
        label,
        countryName,
        cityName,
        area,
        line,
        phone,
      ];
}
