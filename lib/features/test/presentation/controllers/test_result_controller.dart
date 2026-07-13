import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../data/models/submit_test_model.dart';

class TestResultController extends GetxController {
  late final TestResultModel testResult;
  late final List<ReviewAnswerModel> reviewAnswers;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    testResult = args['testResult'] as TestResultModel;
    reviewAnswers = args['reviewAnswers'] as List<ReviewAnswerModel>? ?? [];
  }

  String get readinessLabel {
    if (testResult.score >= 90) return 'Excellent';
    if (testResult.score >= 70) return 'Almost Ready';
    if (testResult.score >= 50) return 'Improving';
    return 'Needs Work';
  }

  void retakeTest() {
    Get.offNamed(AppRoutes.exam, arguments: {'testNumber': testResult.testNumber});
  }

  void reviewAllAnswers() {
    Get.toNamed(AppRoutes.reviewAnswers, arguments: {'reviewAnswers': reviewAnswers});
  }
  void completeExam() {
    Get.toNamed(AppRoutes.main,);
  }
}
