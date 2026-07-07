import 'package:equatable/equatable.dart';

class AddItemParams extends Equatable {
  final int restaurantId;
  final int categoryId;
  final String nameEn;
  final String nameAr;
  final String image;
  final String descriptionEn;
  final String descriptionAr;
  final String price;
  final bool isActive;

  const AddItemParams({
    required this.restaurantId,
    required this.categoryId,
    required this.nameEn,
    required this.nameAr,
    required this.image,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.price,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    final map = {
      "restaurant_id": restaurantId,
      "category_id": categoryId,
      "name_en": nameEn,
      "name_ar": nameAr,
      "image": image,
      "description_en": descriptionEn,
      "description_ar": descriptionAr,
      "price": price,
      "is_active": isActive,
    };

    return map;
  }

  @override
  List<Object?> get props =>
      [restaurantId, categoryId, nameEn, nameAr, image, descriptionEn, descriptionAr, price, isActive];
}
