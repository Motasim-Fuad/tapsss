import 'package:get/get.dart';
import '../../data/datasources/progress_remote_datasource.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../domain/repositories/progress_repository.dart';
import '../controllers/progress_controller.dart';

class ProgressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProgressRepository>(
        () => ProgressRepositoryImpl(ProgressRemoteDataSource(Get.find())));
    Get.lazyPut(() => ProgressController(progressRepository: Get.find()));
  }
}
