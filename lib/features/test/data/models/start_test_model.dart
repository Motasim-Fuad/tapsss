import '../../../../core/utils/json_parsers.dart';

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
    return QuestionModel(
      id: asString(json['_id']),
      questionText: asString(json['questionText']),
      image: (json['image']?.toString().isNotEmpty ?? false)
          ? json['image'].toString()
          : null,
      options: asStringMap(json['options']),
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
    final test = asJsonMap(json['test']);
    return StartTestModel(
      testNumber: asInt(test['testNumber']),
      testName: asString(test['testName']),
      durationMinutes: asInt(test['durationMinutes']),
      totalQuestions: asInt(test['totalQuestions']),
      passingPercentage: asInt(test['passingPercentage'], fallback: 70),
      questions: asJsonMapList(json['questions'])
          .map(QuestionModel.fromJson)
          .toList(),
    );
  }
}
