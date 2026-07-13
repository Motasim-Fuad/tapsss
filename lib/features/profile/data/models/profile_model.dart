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
      totalTests: json['totalTests'] ?? 0,
      completedCount: json['completedCount'] ?? 0,
      bestScore: json['bestScore'] ?? 0,
      averageScore: json['averageScore'] ?? 0,
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
      streak: user['streak'] ?? 0,
      testStats: TestStatsModel.fromJson(json['testStats'] ?? {}),
    );
  }
}
