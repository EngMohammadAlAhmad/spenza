class CreateAndUpdateComboParams {
  final int? id;
  final int restaurantId;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final num price;
  final bool isActive;
  final String image;
  final List<ComboStepParams> comboSteps;

  CreateAndUpdateComboParams({
    this.id,
    required this.restaurantId,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    required this.isActive,
    required this.image,
    required this.comboSteps,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "restaurant_id": restaurantId,
      "name_ar": nameAr,
      "name_en": nameEn,
      "description_ar": descriptionAr,
      "description_en": descriptionEn,
      "price": price,
      "is_active": isActive,
      "image": image,
      "combo_steps": comboSteps.map((step) => step.toJson()).toList(),
    };
  }
}

class ComboStepParams {
  final int? id;
  final String nameAr;
  final String nameEn;
  final int minSelect;
  final int maxSelect;
  final bool isRequired;
  final int sortOrder;
  final List<ComboStepItemParams> comboStepItems;

  ComboStepParams({
    this.id,
    required this.nameAr,
    required this.nameEn,
    required this.minSelect,
    required this.maxSelect,
    required this.isRequired,
    required this.sortOrder,
    required this.comboStepItems,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "name_ar": nameAr,
      "name_en": nameEn,
      "min_select": minSelect,
      "max_select": maxSelect,
      "is_required": isRequired,
      "sort_order": sortOrder,
      "combo_step_items": comboStepItems.map((item) => item.toJson()).toList(),
    };
  }
}

class ComboStepItemParams {
  final int? id;
  final int menuItemId;
  final num extraPrice;
  final int maxQuantity;

  ComboStepItemParams({
    this.id,
    required this.menuItemId,
    required this.extraPrice,
    required this.maxQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'menu_item_id': menuItemId,
      'extra_price': extraPrice,
      'max_quantity': maxQuantity,
    };
  }
}