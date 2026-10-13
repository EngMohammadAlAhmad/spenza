import 'package:spenza/features/orders/domain/entities/order_delivery_address_entity.dart';

class OrderDeliveryAddressModel extends OrderDeliveryAddressEntity {
  const OrderDeliveryAddressModel({
    required super.label,
    required super.countryName,
    required super.cityName,
    required super.area,
    required super.line,
    required super.phone,
  });

  factory OrderDeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    return OrderDeliveryAddressModel(
      label: json['label']?.toString() ?? '',
      countryName: json['country_name']?.toString() ?? '',
      cityName: json['city_name']?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      line: json['line']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'country_name': countryName,
        'city_name': cityName,
        'area': area,
        'line': line,
        'phone': phone,
      };
}
