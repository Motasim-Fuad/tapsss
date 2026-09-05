import 'dart:async';
import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/error/exceptions.dart';
import '../../../subscription/presentation/controllers/subscription_access_controller.dart';
import '../../data/models/start_test_model.dart';
import '../../domain/repositories/test_repository.dart';

class ExamController extends GetxController {
  final TestRepository testRepository;

  ExamController({required this.testRepository});

  late final int testNumber;

  final Rxn<StartTestModel> examData = Rxn<StartTestModel>();
  final RxInt currentIndex = 0.obs;
  final RxMap<String, String> selectedAnswers = <String, String>{}.obs;



  final RxInt remainingSeconds = 0.obs;
  int _totalSeconds = 0;
  Timer? _timer;

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    testNumber = args['testNumber'] ?? 0;
    if (!SubscriptionAccessController.to.canAccessTest(testNumber)) {
      isLoading.value = false;
      Future.microtask(() {
        Get.back();
        SubscriptionAccessController.to.openPaywall();
      });
      return;
    }
    ever(SubscriptionAccessController.to.isPremium, (premium) {
      if (!premium &&
          !SubscriptionAccessController.to.canAccessTest(testNumber)) {
        _timer?.cancel();
        Get.back();
        SubscriptionAccessController.to.openPaywall();
      }
    });
    _startExam();
  }

  Future<void> _startExam() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final data = await testRepository.startTest(testNumber);
      examData.value = data;
      _totalSeconds = data.durationMinutes * 60;
      remainingSeconds.value = _totalSeconds;
      _startTimer();
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value <= 0) {
        timer.cancel();
        submitExam();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  String get formattedTime {
    final minutes = (remainingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  QuestionModel get currentQuestion => examData.value!.questions[currentIndex.value];

  double get progress =>
      examData.value == null ? 0 : (currentIndex.value + 1) / examData.value!.questions.length;

  bool get isLastQuestion =>
      examData.value != null && currentIndex.value == examData.value!.questions.length - 1;

  bool get isFirstQuestion => currentIndex.value == 0;

  void selectAnswer(String option) {
    selectedAnswers[currentQuestion.id] = option;
  }



  void nextQuestion() {
    if (!isLastQuestion) currentIndex.value++;
  }

  void previousQuestion() {
    if (!isFirstQuestion) currentIndex.value--;
  }

  Future<void> submitExam() async {
    _timer?.cancel();
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    errorMessage.value = null;

    try {
      final answers = examData.value!.questions
          .map((q) => {
        'questionId': q.id,
        'selectedAnswer': selectedAnswers[q.id],
      }).toList();

      final timeTaken = _totalSeconds - remainingSeconds.value;

      final result = await testRepository.submitTest(
        testNumber: testNumber,
        answers: answers,
        timeTaken: timeTaken,
      );

      Get.offNamed(AppRoutes.testResult, arguments: {
        'testResult': result.testResult,
        'reviewAnswers': result.reviewAnswers,
      });
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      isSubmitting.value = false;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.'.tr;
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
