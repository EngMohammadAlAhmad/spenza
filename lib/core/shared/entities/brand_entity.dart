import 'package:equatable/equatable.dart';

class BrandEntity extends Equatable{
  final int id;
  final String name;
  final String? image;
  final int? productsCount; // this parameter is used in brands feature , but not in home feature

  const BrandEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.productsCount,
  });

  @override
  List<Object?> get props => [id, name, image, productsCount];
}