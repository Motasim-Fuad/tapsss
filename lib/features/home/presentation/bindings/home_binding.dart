import 'package:get/get.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl(HomeRemoteDataSource(Get.find())));
    Get.lazyPut(() => HomeController(homeRepository: Get.find()));
  }
}
