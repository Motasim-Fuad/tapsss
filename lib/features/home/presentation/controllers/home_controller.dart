import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/error/exceptions.dart';
import '../../data/models/dashboard_model.dart';
import '../../domain/repositories/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository homeRepository;

  HomeController({required this.homeRepository});

  final Rxn<DashboardModel> dashboard = Rxn<DashboardModel>();
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      dashboard.value = await homeRepository.getDashboard();
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void openChapter(String chapterId) {
    Get.toNamed(AppRoutes.chapterDetail, arguments: {'chapterId': chapterId});
  }
}
