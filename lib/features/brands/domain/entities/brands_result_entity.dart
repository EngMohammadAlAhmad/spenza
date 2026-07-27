import 'package:equatable/equatable.dart';
import 'package:spenza/core/shared/entities/brand_entity.dart';

class BrandsResultEntity extends Equatable {
  final List<BrandEntity> brands;
  final int currentPage;
  final int lastPage;
  final int total;

  const BrandsResultEntity({
    required this.brands,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  @override
  List<Object?> get props => [brands, currentPage, lastPage, total];
}
