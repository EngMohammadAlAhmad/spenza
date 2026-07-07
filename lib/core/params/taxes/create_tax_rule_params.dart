class CreateTaxRuleParams {
  final int restaurantId;
  final int taxTypeId;
  final String availableFrom;
  final String availableUntil;
  final num rate;
  final bool appliesToAllItems;
  final bool isActive;
  final int? categoryId;
  final int createdBy;

  CreateTaxRuleParams({
    required this.restaurantId,
    required this.taxTypeId,
    required this.availableFrom,
    required this.availableUntil,
    required this.rate,
    required this.appliesToAllItems,
    required this.isActive,
    required this.categoryId,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'restaurant_id': restaurantId,
      'tax_type_id': taxTypeId,
      'available_from': availableFrom,
      'available_until': availableUntil,
      'rate': rate,
      'applies_to_all_items': appliesToAllItems,
      'is_active': isActive,
      'category_id': categoryId,
      'created_by': createdBy,
    };
  }
}
