class UpdateTaxTypeParams {
  final int id;
  final int restaurantId;
  final String name_ar;
  final String name_en;
  final bool isActive;
  UpdateTaxTypeParams({
    required this.id,
    required this.restaurantId,
    required this.name_ar,
    required this.name_en,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      //'restaurant_id': restaurantId,
      'name_ar': name_ar,
      'name_en': name_en,
      'is_active': isActive,
    };
  }
}
