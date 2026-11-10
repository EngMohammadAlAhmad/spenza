import 'package:easy_localization/easy_localization.dart';
import 'package:spenza/core/shared/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.image,
    required super.productsCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final rawName = (json['name'] as String?)?.trim() ?? '';
    return CategoryModel(
      id: json['id'] ?? 0,
      name: rawName.isNotEmpty ? rawName : 'no_category_name'.tr(),
      image: json['image'] ?? '',
      productsCount: json['products_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'products_count': productsCount,
    };
  }
}
