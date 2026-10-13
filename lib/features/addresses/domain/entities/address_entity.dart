import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final int id;
  final String type;
  final String typeLabel;
  final String label;
  final String displayLabel;
  final int countryId;
  final String countryName;
  final int cityId;
  final String cityName;
  final String area;
  final String street;
  final String building;
  final String floor;
  final String phone;
  final String line;
  final bool isDefault;
  final String? createdAt;
  final String? updatedAt;

  const AddressEntity({
    required this.id,
    required this.type,
    required this.typeLabel,
    required this.label,
    required this.displayLabel,
    required this.countryId,
    required this.countryName,
    required this.cityId,
    required this.cityName,
    required this.area,
    required this.street,
    required this.building,
    required this.floor,
    required this.phone,
    required this.line,
    required this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  /// Displays header title like "المنزل • دمشق"
  String get fullTitle {
    final titleLabel = label.isNotEmpty
        ? label
        : (typeLabel.isNotEmpty
            ? typeLabel
            : (type == 'home'
                ? 'المنزل'
                : (type == 'work' ? 'العمل' : 'آخر')));
    final location = cityName.isNotEmpty ? cityName : countryName;
    if (location.isNotEmpty) {
      return '$titleLabel • $location';
    }
    return titleLabel;
  }

  /// Displays address detail string like "المزة، شارع الجلاء، بناء 12، طابق 3"
  String get fullAddressLine {
    if (line.isNotEmpty) return line;
    final parts = <String>[];
    if (area.isNotEmpty) parts.add(area);
    if (street.isNotEmpty) parts.add(street);
    if (building.isNotEmpty) parts.add(building);
    if (floor.isNotEmpty) parts.add(floor);
    return parts.join('، ');
  }

  /// Formatted phone string with LTR directional isolation marker
  String get formattedPhone {
    var cleaned = phone.replaceAll(RegExp(r'\s+'), '');
    if (cleaned.startsWith('+963')) {
      cleaned = '0${cleaned.substring(4)}';
    } else if (cleaned.startsWith('00963')) {
      cleaned = '0${cleaned.substring(5)}';
    } else if (cleaned.startsWith('963') && cleaned.length == 12) {
      cleaned = '0${cleaned.substring(3)}';
    }

    if (cleaned.length == 9) {
      cleaned = '0$cleaned';
    }

    if (cleaned.length == 10) {
      return '\u200E${cleaned.substring(0, 4)} ${cleaned.substring(4, 7)} ${cleaned.substring(7)}';
    }
    return '\u200E$phone';
  }

  @override
  List<Object?> get props => [
        id,
        type,
        typeLabel,
        label,
        displayLabel,
        countryId,
        countryName,
        cityId,
        cityName,
        area,
        street,
        building,
        floor,
        phone,
        line,
        isDefault,
        createdAt,
        updatedAt,
      ];
}
