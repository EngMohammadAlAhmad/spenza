class CreateTaxTypeParams {
  final int restaurantId;
  final String name_ar;
  final String name_en;
  final String code;
  final String taxCalculationType;
  final bool isActive;
  final int createdBy;

  CreateTaxTypeParams({
    required this.restaurantId,
    required this.name_ar,
    required this.name_en,
    required this.code,
    required this.taxCalculationType,
    required this.isActive,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'restaurant_id': restaurantId,
      'name_ar': name_ar,
      'name_en': name_en,
      'code': code,
      'tax_calculation_type': taxCalculationType,
      'is_active': isActive,
      'created_by': createdBy,
    };
  }
}
