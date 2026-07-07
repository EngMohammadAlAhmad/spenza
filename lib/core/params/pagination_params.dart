

import 'package:spenza/core/utils/base_parameters.dart';

class PaginationParams extends BaseParameters {
  final int pageNumber;
  final int pageSize;

  const PaginationParams({
    this.pageNumber = 1,
    this.pageSize = 10,
  });

  @override
  Map<String, dynamic> toJson() => {
    'pageNumber': pageNumber,
    'pageSize': pageSize,
  };

  @override
  List<Object?> get props => [pageNumber, pageSize];
}
