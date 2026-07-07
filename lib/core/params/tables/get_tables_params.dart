import 'package:equatable/equatable.dart';

class TablesPaginationParams extends Equatable {
  final int restaurantId;
  final int pageNumber;
  final int pageSize;
  final int? sectionId;
  final int? status;

  const TablesPaginationParams({
    required this.restaurantId,
    this.pageNumber = 1,
    this.pageSize = 10,
    this.sectionId,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final map = {
      "restaurant_id": restaurantId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };

    if (sectionId != null) map["section_id"] = sectionId!;
    if (status != null) map["status"] = status!;

    return map;
  }

  @override
  List<Object?> get props =>
      [restaurantId, pageNumber, pageSize, sectionId, status];
}
