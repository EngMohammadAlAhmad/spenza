class ChangePasswordParams {
  final String oldPassword;
  final String newPassword;
  final String confirmNewPassword;

  ChangePasswordParams({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'new_password': newPassword,
      'confirm_new_password': confirmNewPassword,
    };
  }
}
