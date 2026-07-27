import 'package:equatable/equatable.dart';
import 'package:spenza/core/shared/entities/category_entity.dart';

class CategoriesResultEntity extends Equatable {
  final List<CategoryEntity> categories;
  final int currentPage;
  final int lastPage;
  final int total;

  const CategoriesResultEntity({
    required this.categories,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  @override
  List<Object?> get props => [categories, currentPage, lastPage, total];
}
