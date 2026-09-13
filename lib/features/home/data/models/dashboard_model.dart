import '../../../../core/utils/json_parsers.dart';

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
      chapterNumber: asInt(json['chapterNumber']),
      chapterId: json['chapterId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? '',
      totalLessons: asInt(json['totalLessons']),
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
      examReadinessScore: asInt(json['examReadinessScore']),
      examStatus: json['examStatus']?.toString() ?? '',
      totalTests: asInt(json['totalTests']),
      testsDone: asInt(json['testsDone']),
      streak: asInt(json['streak']),
      studyTopics: (json['studyTopics'] as List? ?? [])
          .map((e) => StudyTopicModel.fromJson(e))
          .toList(),
      recentActivity: (json['recentActivity'] as List? ?? [])
          .map((e) => RecentActivityModel.fromJson(e))
          .toList(),
    );
  }
}
