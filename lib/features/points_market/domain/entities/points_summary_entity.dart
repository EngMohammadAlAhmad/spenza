import 'package:equatable/equatable.dart';

class PointsSummaryEntity extends Equatable {
  final int balance;
  final int earned;
  final int spent;
  final int redemptions;

  const PointsSummaryEntity({
    required this.balance,
    required this.earned,
    required this.spent,
    required this.redemptions,
  });

  @override
  List<Object?> get props => [balance, earned, spent, redemptions];
}
