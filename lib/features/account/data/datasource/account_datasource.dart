import 'package:spenza/core/databases/api/api_consumer.dart';
import 'package:spenza/core/databases/api/end_points.dart';
import 'package:spenza/features/account/data/models/user_model.dart';

class AccountDatasource {
  final ApiConsumer api;

  AccountDatasource({required this.api});

  Future<UserModel> getUserProfile() async {
    final response = await api.get(EndPoints.getProfile);
    return UserModel.fromJson(response);
  }
}
