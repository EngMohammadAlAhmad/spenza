import 'package:spenza/features/auth/domain/entities/auth_result_entity.dart';

class AuthResultModel extends AuthResultEntity {
  const AuthResultModel({
    required super.message,
    super.token,
  });

  factory AuthResultModel.fromJson(Map<String, dynamic> json) {
    return AuthResultModel(
      message: json['message'] ?? '',
      token: json['data']?['token'],
    );
  }
}
