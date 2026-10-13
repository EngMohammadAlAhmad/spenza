import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String phoneNumber;
  final bool phoneVerified;
  final String roleLabel;
  final String priceTierLabel;

  const UserEntity({
    required this.id,
    required this.name,
    this.email,
    required this.phoneNumber,
    this.phoneVerified = false,
    required this.roleLabel,
    required this.priceTierLabel,
  });

  String get initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final first = parts[0].isNotEmpty ? parts[0][0] : '';
      final second = parts[1].isNotEmpty ? parts[1][0] : '';
      return '$first $second'.trim();
    } else if (parts[0].isNotEmpty) {
      return parts[0][0];
    }
    return '';
  }

  String get formattedPhoneNumber {
    var cleaned = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    if (cleaned.startsWith('+963')) {
      cleaned = '0${cleaned.substring(4)}';
    } else if (cleaned.startsWith('00963')) {
      cleaned = '0${cleaned.substring(5)}';
    } else if (cleaned.startsWith('963') && cleaned.length == 12) {
      cleaned = '0${cleaned.substring(3)}';
    }

    if (cleaned.length == 9) {
      cleaned = '0$cleaned';
    }

    if (cleaned.length == 10) {
      return '\u200E${cleaned.substring(0, 4)} ${cleaned.substring(4, 7)} ${cleaned.substring(7)}';
    }
    return '\u200E$phoneNumber';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        phoneVerified,
        roleLabel,
        priceTierLabel,
      ];
}
