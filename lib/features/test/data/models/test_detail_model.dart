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
      testNumber: json['testNumber'] ?? 0,
      testName: json['testName']?.toString() ?? '',
      durationMinutes: json['durationMinutes'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      passingPercentage: json['passingPercentage'] ?? 70,
      isCompleted: json['isCompleted'] == true,
      bestScore: json['bestScore'],
      passed: json['passed'] == true,
      action: json['action']?.toString() ?? 'Start Test',
    );
  }
}
