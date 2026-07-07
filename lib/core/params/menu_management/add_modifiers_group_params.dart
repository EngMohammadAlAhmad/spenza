import 'package:equatable/equatable.dart';

class AddModifiersGroupParams extends Equatable {
  final int restaurantId;
  final String nameEn;
  final String nameAr;
  final int selectionType; // 0 = single, 1 = multi
  final SelectionConstraints? selectionConstraints;
  final List<ModifierOption> modifiers;
  final LinkedItems linkedItems;

  const AddModifiersGroupParams({
    required this.restaurantId,
    required this.nameEn,
    required this.nameAr,
    required this.selectionType,
    this.selectionConstraints,
    required this.modifiers,
    required this.linkedItems,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "restaurant_id": restaurantId,
      "name_en": nameEn,
      "name_ar": nameAr,
      "selection_typ": selectionType,
      "modifiers": modifiers.map((m) => m.toJson()).toList(),
      "linked_items": linkedItems.toJson(),
    };

    // Only include selection_constraints if it's not null (i.e., when selectionType == 1)
    if (selectionConstraints != null) {
      map["selection_constraints"] = selectionConstraints!.toJson();
    }

    return map;
  }

  @override
  List<Object?> get props => [
    restaurantId,
    nameEn,
    nameAr,
    selectionType,
    selectionConstraints,
    modifiers,
    linkedItems,
  ];
}

class SelectionConstraints extends Equatable {
  final bool isRequired;
  final int? minSelection;
  final int? maxSelection;

  const SelectionConstraints({
    required this.isRequired,
    this.minSelection,
    this.maxSelection,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "is_required": isRequired,
    };

    if (minSelection != null) {
      map["min_selection"] = minSelection;
    }

    if (maxSelection != null) {
      map["max_selection"] = maxSelection;
    }

    return map;
  }

  @override
  List<Object?> get props => [isRequired, minSelection, maxSelection];
}

class ModifierOption extends Equatable {
  final String nameEn;
  final String nameAr;
  final String price;

  const ModifierOption({
    required this.nameEn,
    required this.nameAr,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      "name_en": nameEn,
      "name_ar": nameAr,
      "price": price,
    };
  }

  @override
  List<Object?> get props => [nameEn, nameAr, price];
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