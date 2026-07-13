class StudyTopicModel {
  final int chapterNumber;
  final String chapterId;
  final String title;
  final String subtitle;
  final String coverImage;
  final int totalLessons;

  StudyTopicModel({
    required this.chapterNumber,
    required this.chapterId,
    required this.title,
    required this.subtitle,
    required this.coverImage,
    required this.totalLessons,
  });

  factory StudyTopicModel.fromJson(Map<String, dynamic> json) {
    return StudyTopicModel(
      chapterNumber: json['chapterNumber'] ?? 0,
      chapterId: json['chapterId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? '',
      totalLessons: json['totalLessons'] ?? 0,
    );
  }
}

class RecentActivityModel {
  final String id;
  final String type;
  final String title;
  final String timeAgo;

  RecentActivityModel({
    required this.id,
    required this.type,
    required this.title,
    required this.timeAgo,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      id: json['_id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      timeAgo: json['timeAgo']?.toString() ?? '',
    );
  }
}

class DashboardModel {
  final int examReadinessScore;
  final String examStatus;
  final int totalTests;
  final int testsDone;
  final int streak;
  final List<StudyTopicModel> studyTopics;
  final List<RecentActivityModel> recentActivity;

  DashboardModel({
    required this.examReadinessScore,
    required this.examStatus,
    required this.totalTests,
    required this.testsDone,
    required this.streak,
    required this.studyTopics,
    required this.recentActivity,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      examReadinessScore: json['examReadinessScore'] ?? 0,
      examStatus: json['examStatus']?.toString() ?? '',
      totalTests: json['totalTests'] ?? 0,
      testsDone: json['testsDone'] ?? 0,
      streak: json['streak'] ?? 0,
      studyTopics: (json['studyTopics'] as List? ?? [])
          .map((e) => StudyTopicModel.fromJson(e))
          .toList(),
      recentActivity: (json['recentActivity'] as List? ?? [])
          .map((e) => RecentActivityModel.fromJson(e))
          .toList(),
    );
  }
}
