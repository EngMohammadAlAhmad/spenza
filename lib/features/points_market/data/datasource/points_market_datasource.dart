import 'package:spenza/core/databases/api/api_consumer.dart';
import 'package:spenza/core/databases/api/end_points.dart';
import 'package:spenza/features/points_market/data/models/points_summary_model.dart';

class PointsMarketDatasource {
  final ApiConsumer api;

  PointsMarketDatasource({required this.api});

  Future<PointsSummaryModel> getMyPoints() async {
    final response = await api.get(EndPoints.getMyPoints);
    return PointsSummaryModel.fromJson(response);
  }
}
