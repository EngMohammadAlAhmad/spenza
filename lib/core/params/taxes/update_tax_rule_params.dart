class UpdateTaxRuleParams {
  final int id;
  final int taxTypeId;
  final String availableFrom;
  final String availableUntil;
  final num rate;
  final bool isActive;

  UpdateTaxRuleParams({
    required this.id,
    required this.taxTypeId,
    required this.availableFrom,
    required this.availableUntil,
    required this.rate,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'available_from': availableFrom,
      'available_until': availableUntil,
      'rate': rate,
      'is_active': isActive,
    };
  }
}
