import 'package:equatable/equatable.dart';

class AddCategoryParams extends Equatable {
  final int restaurantId;
  final String nameEn;
  final String nameAr;
  final String image;
  final bool isActive;

  const AddCategoryParams({
    required this.restaurantId,
    required this.nameEn,
    required this.nameAr,
    required this.image,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    final map = {
      "restaurant_id": restaurantId,
      "name_en": nameEn,
      "name_ar": nameAr,
      "image": image,
      "is_active": isActive,
    };

    return map;
  }

  @override
  List<Object?> get props =>
      [restaurantId, nameEn, nameAr, image, isActive];
}
