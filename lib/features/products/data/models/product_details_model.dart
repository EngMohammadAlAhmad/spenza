import 'package:easy_localization/easy_localization.dart';
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
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final productJson = data['product'] as Map<String, dynamic>? ?? {};
    return ProductDetailsModel(
      product: ProductItemModel.fromJson(productJson),
      relatedProducts: (data['related_products'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => ProductModel.fromJson(e))
              .toList() ??
          [],
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
    required super.sideImages,
    super.video,
    super.model3d,
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
    super.specifications,
  });

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      mainImage: json['main_image'],
      gallery: (json['gallery'] as List?)?.map((e) => e.toString()).toList() ?? [],
      sideImages: (json['side_images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      video: json['video'],
      model3d: json['model_3d'],
      brand: json['brand'] != null && json['brand'] is Map<String, dynamic>
          ? BrandModel.fromJson(json['brand'] as Map<String, dynamic>)
          : const BrandModel(id: 0, name: '', image: '', productsCount: 0),
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : CategoryModel(id: 0, name: 'no_category_name'.tr(), image: '', productsCount: 0),
      rate: json['rate'] ?? 0,
      ratingsCount: json['ratings_count'] ?? 0,
      price: json['price'] ?? 0,
      discountedPrice: json['discounted_price'] ?? 0,
      discountPercentage: json['discount_percentage'] ?? 0,
      defaultUnitId: json['default_unit_id'] ?? 0,
      units: (json['units'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => ProductUnitModel.fromJson(e))
              .toList() ??
          [],
      variantOptions: (json['variant_options'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => ProductVariantOptionModel.fromJson(e))
              .toList() ??
          [],
      variants: (json['variants'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => ProductVariantModel.fromJson(e))
              .toList() ??
          [],
      defaultVariantId: json['default_variant_id'] ?? 0,
      storage: json['storage'] != null && json['storage'] is Map<String, dynamic>
          ? ProductStorageModel.fromJson(json['storage'] as Map<String, dynamic>)
          : const ProductStorageModel(qtyAvailable: 0, inStock: true, isLowStock: false),
      specifications: (json['specifications'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => ProductSpecificationModel.fromJson(e))
              .toList() ??
          [],
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
      values: (json['values'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => ProductVariantOptionValueModel.fromJson(e))
              .toList() ??
          [],
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

class ProductSpecificationModel extends ProductSpecificationEntity {
  const ProductSpecificationModel({
    required super.attributeId,
    required super.name,
    required super.values,
  });

  factory ProductSpecificationModel.fromJson(Map<String, dynamic> json) {
    return ProductSpecificationModel(
      attributeId: json['attribute_id'] ?? 0,
      name: json['name'] ?? '',
      values: (json['values'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => ProductSpecificationValueModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ProductSpecificationValueModel extends ProductSpecificationValueEntity {
  const ProductSpecificationValueModel({
    required super.valueId,
    required super.name,
  });

  factory ProductSpecificationValueModel.fromJson(Map<String, dynamic> json) {
    return ProductSpecificationValueModel(
      valueId: json['value_id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
