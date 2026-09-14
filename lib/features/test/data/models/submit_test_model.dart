import '../../../../core/utils/json_parsers.dart';

class TestResultModel {
  final int testNumber;
  final String testName;
  final int totalQuestions;
  final int score;
  final int correctCount;
  final int incorrectCount;
  final int accuracyRate;
  final int timeTaken;
  final String timeTakenFormatted;

  TestResultModel({
    required this.testNumber,
    required this.testName,
    required this.totalQuestions,
    required this.score,
    required this.correctCount,
    required this.incorrectCount,
    required this.accuracyRate,
    required this.timeTaken,
    required this.timeTakenFormatted,
  });

  factory TestResultModel.fromJson(Map<String, dynamic> json) {
    return TestResultModel(
      testNumber: asInt(json['testNumber']),
      testName: json['testName']?.toString() ?? '',
      totalQuestions: asInt(json['totalQuestions']),
      score: asInt(json['score']),
      correctCount: asInt(json['correctCount']),
      incorrectCount: asInt(json['incorrectCount']),
      accuracyRate: asInt(json['accuracyRate']),
      timeTaken: asInt(json['timeTaken']),
      timeTakenFormatted: json['timeTakenFormatted']?.toString() ?? '',
    );
  }
}

class TopicModel {
  final String chapterId;
  final String title;

  TopicModel({required this.chapterId, required this.title});

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      chapterId: json['chapterId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
    );
  }
}

class ReviewAnswerModel {
  final String questionId;
  final String questionText;
  final String? image;
  final Map<String, String> options;
  final String? selectedAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final TopicModel? topic;

  ReviewAnswerModel({
    required this.questionId,
    required this.questionText,
    this.image,
    required this.options,
    this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    this.topic,
  });

  factory ReviewAnswerModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = asStringMap(json['options']);
    final topicJson = json['topic'];
    return ReviewAnswerModel(
      questionId: asString(json['questionId']),
      questionText: asString(json['questionText']),
      image: (json['image']?.toString().isNotEmpty ?? false) ? json['image'].toString() : null,
      options: rawOptions,
      selectedAnswer: json['selectedAnswer']?.toString(),
      correctAnswer: asString(json['correctAnswer']),
      isCorrect: json['isCorrect'] == true,
      topic: topicJson is Map ? TopicModel.fromJson(asJsonMap(topicJson)) : null,
    );
  }
}

class SubmitTestModel {
  final TestResultModel testResult;
  final List<ReviewAnswerModel> reviewAnswers;

  SubmitTestModel({required this.testResult, required this.reviewAnswers});

  factory SubmitTestModel.fromJson(Map<String, dynamic> json) {
    return SubmitTestModel(
      testResult: TestResultModel.fromJson(asJsonMap(json['testResult'])),
      reviewAnswers: asJsonMapList(json['reviewAnswers'])
          .map(ReviewAnswerModel.fromJson)
          .toList(),
    );
  }
}