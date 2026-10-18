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

  Future<UserModel> updateProfile({
    required String name,
    required String email,
  }) async {
    final response = await api.post(
      EndPoints.updateProfile,
      data: {
        'name': name,
        'email': email,
      },
    );
    return UserModel.fromJson(response);
  }

  Future<String> requestPhoneChange({
    required String phoneNumber,
  }) async {
    final response = await api.post(
      EndPoints.requestPhoneChange,
      data: {
        'phone_number': phoneNumber,
      },
    );
    if (response is Map<String, dynamic>) {
      return response['message'] as String? ?? 'رمز التحقق في طريقه إلى هاتفك.';
    }
    return 'رمز التحقق في طريقه إلى هاتفك.';
  }

  Future<UserModel> confirmPhoneChange({
    required String phoneNumber,
    required String code,
  }) async {
    final response = await api.post(
      EndPoints.confirmPhoneChange,
      data: {
        'phone_number': phoneNumber,
        'code': code,
      },
    );
    return UserModel.fromJson(response);
  }
}
