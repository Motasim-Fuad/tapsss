import 'package:get/get.dart';
import '../../data/models/submit_test_model.dart';

class ReviewAnswersController extends GetxController {
  late final List<ReviewAnswerModel> reviewAnswers;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    reviewAnswers = args['reviewAnswers'] as List<ReviewAnswerModel>? ?? [];
  }

  int get correctCount => reviewAnswers.where((a) => a.isCorrect).length;

  int get incorrectCount => reviewAnswers.where((a) => !a.isCorrect).length;
}
