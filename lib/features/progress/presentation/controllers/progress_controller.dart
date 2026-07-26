import 'package:get/get.dart';
import '../../../../core/error/exceptions.dart';
import '../../data/models/progress_models.dart';
import '../../domain/repositories/progress_repository.dart';

class ProgressController extends GetxController {
  final ProgressRepository progressRepository;

  ProgressController({required this.progressRepository});

  final Rxn<ProgressOverviewModel> overview = Rxn<ProgressOverviewModel>();
  final RxList<TestHistoryItemModel> testHistory = <TestHistoryItemModel>[].obs;
  final RxList<ScoreHistoryPointModel> scoreHistory = <ScoreHistoryPointModel>[].obs;

  final RxString selectedPeriod = 'week'.obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final results = await Future.wait([
        progressRepository.getOverview(),
        progressRepository.getTestHistory(),
        progressRepository.getScoreHistory(selectedPeriod.value),
      ]);
      overview.value = results[0] as ProgressOverviewModel;
      testHistory.assignAll(results[1] as List<TestHistoryItemModel>);
      scoreHistory.assignAll(results[2] as List<ScoreHistoryPointModel>);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePeriod(String period) async {
    if (selectedPeriod.value == period) return;
    selectedPeriod.value = period;
    try {
      scoreHistory.assignAll(await progressRepository.getScoreHistory(period));
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Failed to load chart data';
    }
  }
}
