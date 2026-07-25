import 'package:spenza/core/shared/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.photo,
    required super.rate,
    required super.reviewsCount,
    required super.brand,
    required super.price,
    required super.discountedPrice,
    required super.discountPercentage,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      photo: json['photo'] ?? '',
      rate: json['rate'] ?? 0,
      reviewsCount: json['reviews_count'] ?? 0,
      brand: json['brand'] ?? '',
      price: json['price'] ?? 0,
      discountedPrice: json['discounted_price'] ?? 0,
      discountPercentage: json['discount_percentage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'photo': photo,
      'rate': rate,
      'reviews_count': reviewsCount,
      'brand': brand,
      'price': price,
      'discounted_price': discountedPrice,
      'discount_percentage': discountPercentage,
    };
  }

}