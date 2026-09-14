import '../../../../core/utils/json_parsers.dart';

class TestDetailModel {
  final int testNumber;
  final String testName;
  final int durationMinutes;
  final int totalQuestions;
  final int passingPercentage;
  final bool isCompleted;
  final int? bestScore;
  final bool passed;
  final String action;

  TestDetailModel({
    required this.testNumber,
    required this.testName,
    required this.durationMinutes,
    required this.totalQuestions,
    required this.passingPercentage,
    required this.isCompleted,
    this.bestScore,
    required this.passed,
    required this.action,
  });

  factory TestDetailModel.fromJson(Map<String, dynamic> json) {
    return TestDetailModel(
      testNumber: asInt(json['testNumber']),
      testName: asString(json['testName']),
      durationMinutes: asInt(json['durationMinutes']),
      totalQuestions: asInt(json['totalQuestions']),
      passingPercentage: asInt(json['passingPercentage'], fallback: 70),
      isCompleted: json['isCompleted'] == true,
      bestScore: asIntOrNull(json['bestScore']),
      passed: json['passed'] == true,
      action: asString(json['action'], fallback: 'Start Test'),
    );
  }
}
