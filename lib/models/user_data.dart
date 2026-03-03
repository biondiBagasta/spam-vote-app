class UserData {
  final int? id;
  final DateTime? createdAt;
  final String? username;
  final String? password;
  final bool? isAuthenticated;
  final bool? isBlocked;

  UserData({
    this.id,
    this.createdAt,
    this.username,
    this.password,
    this.isAuthenticated,
    this.isBlocked,
  });

  factory UserData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserData();

    return UserData(
      id: json['id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      username: json['username'] as String?,
      password: json['password'] as String?,
      isAuthenticated: json['is_authenticated'] != null
          ? json['is_authenticated'] == 1 || json['is_authenticated'] == true
          : null,
      isBlocked: json['is_blocked'] != null
          ? json['is_blocked'] == 1 || json['is_blocked'] == true
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'username': username,
      'password': password,
      'is_authenticated': isAuthenticated == true ? 1 : 0,
      'is_blocked': isBlocked == true ? 1 : 0,
    };
  }
}