class QuestionModel {
  final String id;
  final String questionText;
  final String? image;
  final Map<String, String> options;

  QuestionModel({
    required this.id,
    required this.questionText,
    this.image,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'] as Map<String, dynamic>? ?? {};
    return QuestionModel(
      id: json['_id']?.toString() ?? '',
      questionText: json['questionText']?.toString() ?? '',
      image: (json['image']?.toString().isNotEmpty ?? false) ? json['image'].toString() : null,
      options: rawOptions.map((key, value) => MapEntry(key, value.toString())),
    );
  }
}

class StartTestModel {
  final int testNumber;
  final String testName;
  final int durationMinutes;
  final int totalQuestions;
  final int passingPercentage;
  final List<QuestionModel> questions;

  StartTestModel({
    required this.testNumber,
    required this.testName,
    required this.durationMinutes,
    required this.totalQuestions,
    required this.passingPercentage,
    required this.questions,
  });

  factory StartTestModel.fromJson(Map<String, dynamic> json) {
    final test = json['test'] ?? {};
    return StartTestModel(
      testNumber: test['testNumber'] ?? 0,
      testName: test['testName']?.toString() ?? '',
      durationMinutes: test['durationMinutes'] ?? 0,
      totalQuestions: test['totalQuestions'] ?? 0,
      passingPercentage: test['passingPercentage'] ?? 70,
      questions:
          (json['questions'] as List? ?? []).map((e) => QuestionModel.fromJson(e)).toList(),
    );
  }
}
