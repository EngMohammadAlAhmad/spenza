import 'package:spenza/features/account/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    super.email,
    required super.phoneNumber,
    super.phoneVerified,
    required super.roleLabel,
    required super.priceTierLabel,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> userMap = json['data']?['user'] as Map<String, dynamic>? ??
        json['user'] as Map<String, dynamic>? ??
        json;

    return UserModel(
      id: userMap['id'] as int? ?? 0,
      name: userMap['name'] as String? ?? '',
      email: userMap['email'] as String?,
      phoneNumber: userMap['phone_number'] as String? ?? '',
      phoneVerified: userMap['phone_verified'] as bool? ?? false,
      roleLabel: userMap['role'] is Map
          ? (userMap['role']['label'] as String? ?? '')
          : (userMap['role'] as String? ?? ''),
      priceTierLabel: userMap['price_tier'] is Map
          ? (userMap['price_tier']['label'] as String? ?? '')
          : (userMap['price_tier'] as String? ?? ''),
    );
  }
}
