import 'package:equatable/equatable.dart';

class OrderDeliveryEntity extends Equatable {
  final String method;
  final String methodLabel;
  final String description;
  final int etaHours;
  final String etaLabel;
  final num fee;

  const OrderDeliveryEntity({
    required this.method,
    required this.methodLabel,
    required this.description,
    required this.etaHours,
    required this.etaLabel,
    required this.fee,
  });

  @override
  List<Object?> get props => [
        method,
        methodLabel,
        description,
        etaHours,
        etaLabel,
        fee,
      ];
}
