class UserModel {
  final String username;
  final String email;
  final int wins;
  final String role;

  UserModel({
    required this.username,
    required this.email,
    required this.wins,
    required this.role,
  });

  // Factory constructor to create a UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      wins: data['wins'] ?? 0,
    );
  }

  // Convert the UserModel to a Map (optional, for saving/updating data)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'wins': wins,
    };
  }
}