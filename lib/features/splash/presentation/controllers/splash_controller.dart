import 'package:arashmati_app/core/services/preference_service.dart';
import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/storage_service.dart';
import '../../../auth/presentation/controllers/auth_session_controller.dart';

class SplashController extends GetxController {
  // final StorageService storageService;
  final PreferenceService preferenceService;
  final AuthSessionController sessionController;

  SplashController({required this.preferenceService, required this.sessionController});

  @override
  void onInit() {
    super.onInit();
    print('SPLASH: onInit called');
    _decideNextRoute();
  }

  Future<void> _decideNextRoute() async {
    print('SPLASH: waiting 1400ms');
    await Future.delayed(const Duration(milliseconds: 1400));
    print('SPLASH: delay finished, checking onboarding flag');

    try {
      final hasSeenOnboarding = preferenceService.getBool(StorageKeys.hasSeenOnboarding);
      print('SPLASH: hasSeenOnboarding = $hasSeenOnboarding');

      if (!hasSeenOnboarding) {
        Get.offAllNamed(AppRoutes.onboarding);
        return;
      }

      print('SPLASH: checking session token');
      final hasSession = await sessionController.hasValidSession();
      print('SPLASH: hasSession = $hasSession');

      if (hasSession) {
        print('SPLASH: navigating to main');
        Get.offAllNamed(AppRoutes.main);
      } else {
        print('SPLASH: navigating to login');
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e, stack) {
      print('SPLASH NAVIGATION ERROR: $e');
      print(stack);
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
