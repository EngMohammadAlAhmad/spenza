import 'package:spenza/core/databases/api/api_consumer.dart';
import 'package:spenza/core/databases/api/end_points.dart';
import 'package:spenza/features/auth/data/models/auth_result_model.dart';
import 'package:spenza/features/auth/data/models/verify_otp_result_model.dart';

class AuthDatasource {
  final ApiConsumer api;

  AuthDatasource({required this.api});

  Future<String> requestOtp(String phoneNumber) async {
    final response = await api.post(
      EndPoints.requestOtp,
      data: {
        'phone_number': phoneNumber,
      },
    );

    return response['message'] as String;
  }

  Future<VerifyOtpResultModel> verifyOtp(String phoneNumber, String code) async {
    final response = await api.post(
      EndPoints.verifyOtp,
      data: {
        'phone_number': phoneNumber,
        'code': code,
      },
    );

    return VerifyOtpResultModel.fromJson(response);
  }

  Future<AuthResultModel> register({
    required String name,
    required String phoneNumber,
    required String code,
  }) async {
    final response = await api.post(
      EndPoints.register,
      data: {
        'name': name,
        'phone_number': phoneNumber,
        'code': code,
        'accepted_terms': true,
        'accepted_privacy': true,
      },
    );

    return AuthResultModel.fromJson(response);
  }
}
