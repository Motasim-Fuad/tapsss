import 'package:arashmati_app/core/services/preference_service.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_session_controller.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      SplashController(
        preferenceService: Get.find<PreferenceService>(),
        sessionController: Get.find<AuthSessionController>(),
      ),
    );
  }
}
