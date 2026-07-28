import 'package:spenza/core/shared/models/brand_model.dart';
import 'package:spenza/core/shared/models/category_model.dart';
import 'package:spenza/core/shared/models/product_model.dart';
import 'package:spenza/features/products/domain/entities/product_details_entity.dart';

class ProductDetailsModel extends ProductDetailsEntity {
  const ProductDetailsModel({
    required super.product,
    required super.relatedProducts,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return ProductDetailsModel(
      product: ProductItemModel.fromJson(data['product'] as Map<String, dynamic>),
      relatedProducts: (data['related_products'] as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProductItemModel extends ProductItemEntity {
  const ProductItemModel({
    required super.id,
    required super.title,
    required super.description,
    super.mainImage,
    required super.gallery,
    required super.brand,
    required super.category,
    required super.rate,
    required super.ratingsCount,
    required super.price,
    required super.discountedPrice,
    required super.discountPercentage,
    required super.defaultUnitId,
    required super.units,
    required super.variantOptions,
    required super.variants,
    required super.defaultVariantId,
    required super.storage,
  });

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      mainImage: json['main_image'],
      gallery: (json['gallery'] as List?)?.map((e) => e.toString()).toList() ?? [],
      brand: BrandModel.fromJson(json['brand'] as Map<String, dynamic>),
      category: CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      rate: json['rate'] ?? 0,
      ratingsCount: json['ratings_count'] ?? 0,
      price: json['price'] ?? 0,
      discountedPrice: json['discounted_price'] ?? 0,
      discountPercentage: json['discount_percentage'] ?? 0,
      defaultUnitId: json['default_unit_id'] ?? 0,
      units: (json['units'] as List)
          .map((e) => ProductUnitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      variantOptions: (json['variant_options'] as List)
          .map((e) => ProductVariantOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      variants: (json['variants'] as List)
          .map((e) => ProductVariantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      defaultVariantId: json['default_variant_id'] ?? 0,
      storage: ProductStorageModel.fromJson(json['storage'] as Map<String, dynamic>),
    );
  }
}

class ProductUnitModel extends ProductUnitEntity {
  const ProductUnitModel({
    required super.id,
    required super.title,
    required super.baseMultiplies,
    required super.price,
    required super.discountedPrice,
    required super.discountPercentage,
  });

  factory ProductUnitModel.fromJson(Map<String, dynamic> json) {
    return ProductUnitModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      baseMultiplies: json['base_multiplies'] ?? 1,
      price: json['price'] ?? 0,
      discountedPrice: json['discounted_price'] ?? 0,
      discountPercentage: json['discount_percentage'] ?? 0,
    );
  }
}

class ProductVariantOptionModel extends ProductVariantOptionEntity {
  const ProductVariantOptionModel({
    required super.attributeId,
    required super.name,
    required super.values,
  });

  factory ProductVariantOptionModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantOptionModel(
      attributeId: json['attribute_id'] ?? 0,
      name: json['name'] ?? '',
      values: (json['values'] as List)
          .map((e) => ProductVariantOptionValueModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProductVariantOptionValueModel extends ProductVariantOptionValueEntity {
  const ProductVariantOptionValueModel({
    required super.valueId,
    required super.name,
    required super.inStock,
  });

  factory ProductVariantOptionValueModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantOptionValueModel(
      valueId: json['value_id'] ?? 0,
      name: json['name'] ?? '',
      inStock: json['in_stock'] ?? true,
    );
  }
}

class ProductVariantModel extends ProductVariantEntity {
  const ProductVariantModel({
    required super.id,
    required super.label,
    required super.selectionKey,
    required super.qtyAvailable,
    required super.inStock,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      selectionKey: json['selection_key'] ?? '',
      qtyAvailable: json['qty_available'] ?? 0,
      inStock: json['in_stock'] ?? true,
    );
  }
}

class ProductStorageModel extends ProductStorageEntity {
  const ProductStorageModel({
    required super.qtyAvailable,
    required super.inStock,
    required super.isLowStock,
  });

  factory ProductStorageModel.fromJson(Map<String, dynamic> json) {
    return ProductStorageModel(
      qtyAvailable: json['qty_available'] ?? 0,
      inStock: json['in_stock'] ?? true,
      isLowStock: json['is_low_stock'] ?? false,
    );
  }
}
