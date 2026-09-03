import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/error/exceptions.dart';
import '../../../subscription/presentation/controllers/subscription_access_controller.dart';
import '../../data/models/study_materials_model.dart';
import '../../domain/repositories/study_repository.dart';

class StudyController extends GetxController {
  final StudyRepository studyRepository;

  StudyController({required this.studyRepository});

  final Rxn<StudyMaterialsModel> materials = Rxn<StudyMaterialsModel>();
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchMaterials();
  }

  Future<void> fetchMaterials() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      materials.value = await studyRepository.getStudyMaterials();
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  void openChapter(ChapterModel chapter) {
    if (!SubscriptionAccessController.to.requireChapterAccess(chapter.chapterNumber)) {
      return;
    }
    Get.toNamed(AppRoutes.chapterDetail, arguments: {'chapterId': chapter.id})
        ?.then((_) => fetchMaterials());
  }
}
