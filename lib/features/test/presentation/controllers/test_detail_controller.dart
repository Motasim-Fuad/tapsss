import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/error/exceptions.dart';
import '../../../subscription/presentation/controllers/subscription_access_controller.dart';
import '../../data/models/test_detail_model.dart';
import '../../domain/repositories/test_repository.dart';

class TestDetailController extends GetxController {
  final TestRepository testRepository;

  TestDetailController({required this.testRepository});

  late final int testNumber;

  final Rxn<TestDetailModel> testDetail = Rxn<TestDetailModel>();
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    testNumber = args['testNumber'] ?? 0;
    ever(SubscriptionAccessController.to.isPremium, (_) => _enforceAccess());
    fetchTestDetail();
  }

  Future<void> fetchTestDetail() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      testDetail.value = await testRepository.getTestByNumber(testNumber);
      _enforceAccess();
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  bool _enforceAccess() {
    if (SubscriptionAccessController.to.canAccessTest(testNumber)) {
      return true;
    }
    Get.back();
    SubscriptionAccessController.to.openPaywall();
    return false;
  }

  void startExam() {
    if (!_enforceAccess()) return;
    Get.toNamed(AppRoutes.exam, arguments: {'testNumber': testNumber});
  }
}
