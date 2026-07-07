class AddUserParams {
  final int restaurantId;
  final String name;
  final String email;
  final String password;
  final String role;

  AddUserParams({
    required this.restaurantId,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'restaurant_id': restaurantId,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
