import '../../../../core/utils/json_parsers.dart';

class ProgressOverviewModel {
  final int readinessScore;
  final String weekChange;
  final int testsDone;
  final int totalTests;
  final int accuracy;
  final int streak;

  ProgressOverviewModel({
    required this.readinessScore,
    required this.weekChange,
    required this.testsDone,
    required this.totalTests,
    required this.accuracy,
    required this.streak,
  });

  factory ProgressOverviewModel.fromJson(Map<String, dynamic> json) {
    return ProgressOverviewModel(
      readinessScore: asInt(json['readinessScore']),
      weekChange: json['weekChange']?.toString() ?? '0%',
      testsDone: asInt(json['testsDone']),
      totalTests: asInt(json['totalTests']),
      accuracy: asInt(json['accuracy']),
      streak: asInt(json['streak']),
    );
  }
}

class TestHistoryItemModel {
  final String testId;
  final String testName;
  final int testNumber;
  final int score;
  final int totalMarks;
  final String date;
  final String statusColor;

  TestHistoryItemModel({
    required this.testId,
    required this.testName,
    required this.testNumber,
    required this.score,
    required this.totalMarks,
    required this.date,
    required this.statusColor,
  });

  factory TestHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return TestHistoryItemModel(
      testId: json['testId']?.toString() ?? '',
      testName: json['testName']?.toString() ?? '',
      testNumber: asInt(json['testNumber']),
      score: asInt(json['score']),
      totalMarks: asInt(json['totalMarks'], fallback: 100),
      date: json['date']?.toString() ?? '',
      statusColor: json['statusColor']?.toString() ?? 'green',
    );
  }
}

class ScoreHistoryPointModel {
  final String testId;
  final int testNumber;
  final String testName;
  final int score;
  final String date;
  final String day;

  ScoreHistoryPointModel({
    required this.testId,
    required this.testNumber,
    required this.testName,
    required this.score,
    required this.date,
    required this.day,
  });

  factory ScoreHistoryPointModel.fromJson(Map<String, dynamic> json) {
    return ScoreHistoryPointModel(
      testId: json['testId']?.toString() ?? '',
      testNumber: asInt(json['testNumber']),
      testName: json['testName']?.toString() ?? '',
      score: asInt(json['score']),
      date: json['date']?.toString() ?? '',
      day: json['day']?.toString() ?? '',
    );
  }
}
