import 'package:get/get.dart';

import '../../../../core/services/preference_service.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
          () => OnboardingController(
        preferenceService: Get.find<PreferenceService>(),
      ),
    );
  }
}