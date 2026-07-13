import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_session_controller.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileRepository>()) {
      Get.lazyPut<ProfileRepository>(
        () => ProfileRepositoryImpl(ProfileRemoteDataSource(Get.find())),
        fenix: true,
      );
    }
    Get.lazyPut(() => ProfileController(
          profileRepository: Get.find(),
          sessionController: Get.find<AuthSessionController>(),
        ));
  }
}

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileController(
          profileRepository: Get.find(),
          sessionController: Get.find<AuthSessionController>(),
        ));
  }
}
