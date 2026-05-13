/// Model representing the authenticated user
class UserModel {
  final String username;
  final String role;
  final DateTime lastLogin;

  UserModel({
    required this.username,
    required this.role,
    required this.lastLogin,
  });

  /// Factory to create a user from a map (for storage)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? 'Guest',
      role: json['role'] ?? 'Trainer',
      lastLogin: json['lastLogin'] != null 
          ? DateTime.parse(json['lastLogin']) 
          : DateTime.now(),
    );
  }

  /// Converts user to a map (for storage)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'role': role,
      'lastLogin': lastLogin.toIso8601String(),
    };
  }

  /// Helper for Guest user
  factory UserModel.guest() => UserModel(
    username: 'Guest',
    role: 'Trainer',
    lastLogin: DateTime.now(),
  );
}
