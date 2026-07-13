import 'package:get/get.dart';
import '../../data/datasources/study_remote_datasource.dart';
import '../../data/repositories/study_repository_impl.dart';
import '../../domain/repositories/study_repository.dart';
import '../controllers/chapter_detail_controller.dart';
import '../controllers/study_controller.dart';

class StudyBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<StudyRepository>()) {
      Get.lazyPut<StudyRepository>(
        () => StudyRepositoryImpl(StudyRemoteDataSource(Get.find())),
        fenix: true,
      );
    }
    Get.lazyPut(() => StudyController(studyRepository: Get.find()));
  }
}

class ChapterDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChapterDetailController(studyRepository: Get.find()));
  }
}
