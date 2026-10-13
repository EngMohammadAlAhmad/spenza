import 'package:spenza/features/auth/domain/entities/verify_otp_result_entity.dart';

class VerifyOtpResultModel extends VerifyOtpResultEntity {
  const VerifyOtpResultModel({
    required super.registered,
    required super.message,
    super.token,
  });

  factory VerifyOtpResultModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResultModel(
      registered: json['data']?['registered'] ?? false,
      message: json['message'] ?? '',
      token: json['data']?['token'],
    );
  }
}
