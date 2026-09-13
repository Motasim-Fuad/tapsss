import '../../../../core/utils/json_parsers.dart';

class TestStatsModel {
  final int totalTests;
  final int completedCount;
  final int bestScore;
  final int averageScore;

  TestStatsModel({
    required this.totalTests,
    required this.completedCount,
    required this.bestScore,
    required this.averageScore,
  });

  factory TestStatsModel.fromJson(Map<String, dynamic> json) {
    return TestStatsModel(
      totalTests: asInt(json['totalTests']),
      completedCount: asInt(json['completedCount']),
      bestScore: asInt(json['bestScore']),
      averageScore: asInt(json['averageScore']),
    );
  }
}

class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? profilePic;
  final bool isVerified;
  final int streak;
  final TestStatsModel testStats;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profilePic,
    required this.isVerified,
    required this.streak,
    required this.testStats,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    return ProfileModel(
      id: user['_id']?.toString() ?? '',
      name: user['name']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      role: user['role']?.toString() ?? 'user',
      profilePic: user['profile_pic']?.toString(),
      isVerified: user['isVerified'] == true,
      streak: asInt(user['streak']),
      testStats: TestStatsModel.fromJson(json['testStats'] ?? {}),
    );
  }
}
