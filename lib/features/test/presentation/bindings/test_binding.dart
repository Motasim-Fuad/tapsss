import 'package:get/get.dart';
import '../../data/datasources/test_remote_datasource.dart';
import '../../data/repositories/test_repository_impl.dart';
import '../../domain/repositories/test_repository.dart';
import '../controllers/exam_controller.dart';
import '../controllers/review_answers_controller.dart';
import '../controllers/test_detail_controller.dart';
import '../controllers/test_list_controller.dart';
import '../controllers/test_result_controller.dart';

class TestBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<TestRepository>()) {
      Get.lazyPut<TestRepository>(
        () => TestRepositoryImpl(TestRemoteDataSource(Get.find())),
        fenix: true,
      );
    }
    Get.lazyPut(() => TestListController(testRepository: Get.find()));
  }
}

class TestDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TestDetailController(testRepository: Get.find()));
  }
}

class ExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExamController(testRepository: Get.find()));
  }
}

class TestResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TestResultController());
  }
}

class ReviewAnswersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReviewAnswersController());
  }
}
