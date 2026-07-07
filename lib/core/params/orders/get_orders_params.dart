import 'package:equatable/equatable.dart';

class GetAllOrdersParams extends Equatable {
  final int restaurantId;
  //final int pageSize;
  //final String status;
  final String sortDirection;

  const GetAllOrdersParams({
    required this.restaurantId,
    //this.pageSize = 1000,
    //required this.status,
    required this.sortDirection,
  });

  Map<String, dynamic> toJson() {
    final map = {
      "restaurant_id": restaurantId,
      //"pageSize": pageSize,
      //"status": status,
      "sort_direction": sortDirection,
    };
    return map;
  }

  @override
  List<Object?> get props => [restaurantId, /*pageSize, status,*/ sortDirection];
}
