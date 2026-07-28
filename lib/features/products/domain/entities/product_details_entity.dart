import 'package:equatable/equatable.dart';
import 'package:spenza/core/shared/entities/brand_entity.dart';
import 'package:spenza/core/shared/entities/category_entity.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';

class ProductDetailsEntity extends Equatable {
  final ProductItemEntity product;
  final List<ProductEntity> relatedProducts;

  const ProductDetailsEntity({
    required this.product,
    required this.relatedProducts,
  });

  @override
  List<Object?> get props => [product, relatedProducts];
}

class ProductItemEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String? mainImage;
  final List<String> gallery;
  final List<String> sideImages;
  final String? video;
  final String? model3d;
  final BrandEntity brand;
  final CategoryEntity category;
  final num rate;
  final int ratingsCount;
  final num price;
  final num discountedPrice;
  final num discountPercentage;
  final int defaultUnitId;
  final List<ProductUnitEntity> units;
  final List<ProductVariantOptionEntity> variantOptions;
  final List<ProductVariantEntity> variants;
  final int defaultVariantId;
  final ProductStorageEntity storage;

  const ProductItemEntity({
    required this.id,
    required this.title,
    required this.description,
    this.mainImage,
    required this.gallery,
    required this.sideImages,
    this.video,
    this.model3d,
    required this.brand,
    required this.category,
    required this.rate,
    required this.ratingsCount,
    required this.price,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.defaultUnitId,
    required this.units,
    required this.variantOptions,
    required this.variants,
    required this.defaultVariantId,
    required this.storage,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        mainImage,
        gallery,
        sideImages,
        video,
        model3d,
        brand,
        category,
        rate,
        ratingsCount,
        price,
        discountedPrice,
        discountPercentage,
        defaultUnitId,
        units,
        variantOptions,
        variants,
        defaultVariantId,
        storage,
      ];
}

class ProductUnitEntity extends Equatable {
  final int id;
  final String title;
  final num baseMultiplies;
  final num price;
  final num discountedPrice;
  final num discountPercentage;

  const ProductUnitEntity({
    required this.id,
    required this.title,
    required this.baseMultiplies,
    required this.price,
    required this.discountedPrice,
    required this.discountPercentage,
  });

  @override
  List<Object?> get props => [id, title, baseMultiplies, price, discountedPrice, discountPercentage];
}

class ProductVariantOptionEntity extends Equatable {
  final int attributeId;
  final String name;
  final List<ProductVariantOptionValueEntity> values;

  const ProductVariantOptionEntity({
    required this.attributeId,
    required this.name,
    required this.values,
  });

  @override
  List<Object?> get props => [attributeId, name, values];
}

class ProductVariantOptionValueEntity extends Equatable {
  final int valueId;
  final String name;
  final bool inStock;

  const ProductVariantOptionValueEntity({
    required this.valueId,
    required this.name,
    required this.inStock,
  });

  @override
  List<Object?> get props => [valueId, name, inStock];
}

class ProductVariantEntity extends Equatable {
  final int id;
  final String label;
  final String selectionKey;
  final int qtyAvailable;
  final bool inStock;

  const ProductVariantEntity({
    required this.id,
    required this.label,
    required this.selectionKey,
    required this.qtyAvailable,
    required this.inStock,
  });

  @override
  List<Object?> get props => [id, label, selectionKey, qtyAvailable, inStock];
}

class ProductStorageEntity extends Equatable {
  final int qtyAvailable;
  final bool inStock;
  final bool isLowStock;

  const ProductStorageEntity({
    required this.qtyAvailable,
    required this.inStock,
    required this.isLowStock,
  });

  @override
  List<Object?> get props => [qtyAvailable, inStock, isLowStock];
}
