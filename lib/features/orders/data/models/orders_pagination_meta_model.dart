import 'package:spenza/features/orders/domain/entities/orders_pagination_meta_entity.dart';

class OrdersPaginationMetaModel extends OrdersPaginationMetaEntity {
  const OrdersPaginationMetaModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory OrdersPaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return OrdersPaginationMetaModel(
      currentPage: _parseInt(json['current_page'] ?? json['currentPage']),
      lastPage: _parseInt(json['last_page'] ?? json['lastPage']),
      perPage: _parseInt(json['per_page'] ?? json['perPage']),
      total: _parseInt(json['total']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 1;
    return 1;
  }

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'last_page': lastPage,
        'per_page': perPage,
        'total': total,
      };
}
