import 'package:equatable/equatable.dart';

class AddPromotionParams extends Equatable {
  final int restaurantId;
  final String nameEn;
  final String nameAr;
  final String descriptionAr;
  final String descriptionEn;
  final String availableFrom;
  final String availableUntil;
  final double discountValue;
  final int discountType; // 0 = value, 1 = percentage
  final String image;
  final LinkedItems linkedItems;

  const AddPromotionParams({
    required this.restaurantId,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.availableFrom,
    required this.availableUntil,
    required this.image,
    required this.discountValue,
    required this.discountType,
    required this.linkedItems,
  });

  Map<String, dynamic> toJson() {
    return {
      "restaurant_id": restaurantId,
      "name_en": nameEn,
      "name_ar": nameAr,
      "description_en": descriptionEn,
      "description_ar": descriptionAr,
      "available_from": availableFrom,
      "available_until": availableUntil,
      "discount_type": discountType,
      "discount_value": discountValue,
      "image": image,
      "linked_items": linkedItems.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    restaurantId,
    nameEn,
    nameAr,
    descriptionEn,
    descriptionAr,
    availableFrom,
    availableUntil,
    discountValue,
    discountType,
    image,
    linkedItems,
  ];
}

class LinkedItems extends Equatable {
  final List<int> fullCategories;
  final List<int> specificItems;

  const LinkedItems({
    this.fullCategories = const [],
    this.specificItems = const [],
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (fullCategories.isNotEmpty) {
      map["full_categories"] = fullCategories;
    }

    if (specificItems.isNotEmpty) {
      map["specific_items"] = specificItems;
    }

    return map;
  }

  @override
  List<Object?> get props => [fullCategories, specificItems];
}