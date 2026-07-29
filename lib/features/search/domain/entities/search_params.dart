import 'package:equatable/equatable.dart';

class SearchParams extends Equatable {
  final String q;
  final int? categoryId;
  final int? brandId;
  final int page;
  final int perPage;

  const SearchParams({
    required this.q,
    this.categoryId,
    this.brandId,
    this.page = 1,
    this.perPage = 20,
  });

  @override
  List<Object?> get props => [q, categoryId, brandId, page, perPage];
}
