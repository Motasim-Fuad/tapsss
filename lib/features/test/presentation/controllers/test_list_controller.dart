import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/error/exceptions.dart';
import '../../data/models/test_list_model.dart';
import '../../domain/repositories/test_repository.dart';

class TestListController extends GetxController {
  final TestRepository testRepository;

  TestListController({required this.testRepository});

  final Rxn<TestListModel> testList = Rxn<TestListModel>();
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchTests();
  }

  Future<void> fetchTests() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      testList.value = await testRepository.getTests();
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  void openTest(int testNumber) {
    Get.toNamed(AppRoutes.testDetail, arguments: {'testNumber': testNumber})
        ?.then((_) => fetchTests());
  }
}
