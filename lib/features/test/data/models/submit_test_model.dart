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
      testNumber: json['testNumber'] ?? 0,
      testName: json['testName']?.toString() ?? '',
      totalQuestions: json['totalQuestions'] ?? 0,
      score: json['score'] ?? 0,
      correctCount: json['correctCount'] ?? 0,
      incorrectCount: json['incorrectCount'] ?? 0,
      accuracyRate: json['accuracyRate'] ?? 0,
      timeTaken: json['timeTaken'] ?? 0,
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
    final rawOptions = json['options'] as Map<String, dynamic>? ?? {};
    return ReviewAnswerModel(
      questionId: json['questionId']?.toString() ?? '',
      questionText: json['questionText']?.toString() ?? '',
      image: (json['image']?.toString().isNotEmpty ?? false) ? json['image'].toString() : null,
      options: rawOptions.map((key, value) => MapEntry(key, value.toString())),
      selectedAnswer: json['selectedAnswer']?.toString(),
      correctAnswer: json['correctAnswer']?.toString() ?? '',
      isCorrect: json['isCorrect'] == true,
      topic: json['topic'] != null ? TopicModel.fromJson(json['topic']) : null,
    );
  }
}

class SubmitTestModel {
  final TestResultModel testResult;
  final List<ReviewAnswerModel> reviewAnswers;

  SubmitTestModel({required this.testResult, required this.reviewAnswers});

  factory SubmitTestModel.fromJson(Map<String, dynamic> json) {
    return SubmitTestModel(
      testResult: TestResultModel.fromJson(json['testResult'] ?? {}),
      reviewAnswers: (json['reviewAnswers'] as List? ?? [])
          .map((e) => ReviewAnswerModel.fromJson(e))
          .toList(),
    );
  }
}