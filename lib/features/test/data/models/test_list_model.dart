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
      completedCount: json['completedCount'] ?? 0,
      totalTests: json['totalTests'] ?? 0,
      bestScore: json['bestScore'],
      avgScore: json['avgScore'],
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
      testNumber: json['testNumber'] ?? 0,
      testName: json['testName']?.toString() ?? '',
      durationMinutes: json['durationMinutes'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      isCompleted: json['isCompleted'] == true,
      bestScore: json['bestScore'],
      passed: json['passed'] == true,
      action: json['action']?.toString() ?? 'Start Test',
    );
  }
}

class TestListModel {
  final TestsOverviewModel overview;
  final List<TestListItemModel> tests;

  TestListModel({required this.overview, required this.tests});

  factory TestListModel.fromJson(Map<String, dynamic> json) {
    return TestListModel(
      overview: TestsOverviewModel.fromJson(json['overview'] ?? {}),
      tests: (json['tests'] as List? ?? []).map((e) => TestListItemModel.fromJson(e)).toList(),
    );
  }
}
