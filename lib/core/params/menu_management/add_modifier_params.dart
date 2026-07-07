import 'package:equatable/equatable.dart';

class AddModifierParams extends Equatable {
  final int restaurantId;
  final int groupId;
  final String nameEn;
  final String nameAr;
  final String price;
  final bool isActive;

  const AddModifierParams({
    required this.restaurantId,
    required this.groupId,
    required this.nameEn,
    required this.nameAr,
    required this.price,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    final map = {
      "restaurant_id": restaurantId,
      "group_id": groupId,
      "name_en": nameEn,
      "name_ar": nameAr,
      "price": price,
      "is_active": isActive,
    };

    return map;
  }

  @override
  List<Object?> get props =>
      [restaurantId, nameEn, nameAr, price, isActive];
}
