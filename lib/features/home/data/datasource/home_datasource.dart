import 'package:spenza/core/databases/api/api_consumer.dart';
import 'package:spenza/core/databases/api/end_points.dart';
import 'package:spenza/core/databases/cache/cache_helper.dart';
import 'package:spenza/features/home/data/models/home_data_model.dart';

class HomeDatasource {
  final ApiConsumer api;
  final CacheHelper cacheHelper;

  HomeDatasource({
    required this.api,
    required this.cacheHelper,
  });

  Future<HomeDataModel> getHomeData() async {

    final response = await api.get(EndPoints.getHome);

    return HomeDataModel.fromJson(response);
  }
}