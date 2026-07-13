class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? profilePic;
  final bool isVerified;
  final int streak;
  final String? lastLoginDate;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profilePic,
    this.isVerified = false,
    this.streak = 0,
    this.lastLoginDate,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'user',
      profilePic: json['profile_pic']?.toString(),
      isVerified: json['isVerified'] == true,
      streak: json['streak'] is int ? json['streak'] : int.tryParse('${json['streak']}') ?? 0,
      lastLoginDate: json['lastLoginDate']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  UserModel copyWith({String? name, String? profilePic}) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      role: role,
      profilePic: profilePic ?? this.profilePic,
      isVerified: isVerified,
      streak: streak,
      lastLoginDate: lastLoginDate,
      createdAt: createdAt,
    );
  }
}
