import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable{
  final int id;
  final String title;
  final String? photo;
  final num rate;
  final int reviewsCount;
  final String brand;
  final num price;
  final num discountedPrice;
  final num discountPercentage;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.photo,
    required this.rate,
    required this.reviewsCount,
    required this.brand,
    required this.price,
    required this.discountedPrice,
    required this.discountPercentage,
  });

  @override
  List<Object?> get props => [id, title, photo, rate, reviewsCount, brand, price, discountedPrice, discountPercentage];
}