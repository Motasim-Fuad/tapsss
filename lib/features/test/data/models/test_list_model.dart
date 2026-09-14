import '../../../../core/utils/json_parsers.dart';

class TestsOverviewModel {
  final int completedCount;
  final int totalTests;
  final int? bestScore;
  final int? avgScore;

  TestsOverviewModel({
    required this.completedCount,
    required this.totalTests,
    this.bestScore,
    this.avgScore,
  });

  factory TestsOverviewModel.fromJson(Map<String, dynamic> json) {
    return TestsOverviewModel(
      completedCount: asInt(json['completedCount']),
      totalTests: asInt(json['totalTests']),
      bestScore: asIntOrNull(json['bestScore']),
      avgScore: asIntOrNull(json['avgScore']),
    );
  }
}

class TestListItemModel {
  final int testNumber;
  final String testName;
  final int durationMinutes;
  final int totalQuestions;
  final bool isCompleted;
  final int? bestScore;
  final bool passed;
  final String action;

  TestListItemModel({
    required this.testNumber,
    required this.testName,
    required this.durationMinutes,
    required this.totalQuestions,
    required this.isCompleted,
    this.bestScore,
    required this.passed,
    required this.action,
  });

  factory TestListItemModel.fromJson(Map<String, dynamic> json) {
    return TestListItemModel(
      testNumber: asInt(json['testNumber']),
      testName: asString(json['testName']),
      durationMinutes: asInt(json['durationMinutes']),
      totalQuestions: asInt(json['totalQuestions']),
      isCompleted: json['isCompleted'] == true,
      bestScore: asIntOrNull(json['bestScore']),
      passed: json['passed'] == true,
      action: asString(json['action'], fallback: 'Start Test'),
    );
  }
}

class TestListModel {
  final TestsOverviewModel overview;
  final List<TestListItemModel> tests;

  TestListModel({required this.overview, required this.tests});

  factory TestListModel.fromJson(Map<String, dynamic> json) {
    final root = json['data'] is Map ? asJsonMap(json['data']) : json;
    return TestListModel(
      overview: TestsOverviewModel.fromJson(asJsonMap(root['overview'])),
      tests: asJsonMapList(root['tests']).map(TestListItemModel.fromJson).toList(),
    );
  }
}
