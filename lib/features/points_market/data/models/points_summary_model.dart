import 'package:spenza/features/points_market/domain/entities/points_summary_entity.dart';

class PointsSummaryModel extends PointsSummaryEntity {
  const PointsSummaryModel({
    required super.balance,
    required super.earned,
    required super.spent,
    required super.redemptions,
  });

  factory PointsSummaryModel.fromJson(Map<String, dynamic> json) {
    final summary = json['data']?['summary'] as Map<String, dynamic>? ?? {};
    return PointsSummaryModel(
      balance: summary['balance'] as int? ?? 0,
      earned: summary['earned'] as int? ?? 0,
      spent: summary['spent'] as int? ?? 0,
      redemptions: summary['redemptions'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'earned': earned,
      'spent': spent,
      'redemptions': redemptions,
    };
  }
}
