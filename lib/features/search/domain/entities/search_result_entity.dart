import 'package:equatable/equatable.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';

class SearchResultEntity extends Equatable {
  final List<ProductEntity> products;
  final int currentPage;
  final int lastPage;
  final int total;

  const SearchResultEntity({
    required this.products,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  @override
  List<Object?> get props => [products, currentPage, lastPage, total];
}
