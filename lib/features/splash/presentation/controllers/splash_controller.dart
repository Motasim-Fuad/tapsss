import 'package:arashmati_app/core/services/preference_service.dart';
import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/storage_service.dart';
import '../../../auth/presentation/controllers/auth_session_controller.dart';
import '../../../subscription/presentation/controllers/subscription_access_controller.dart';

class SplashController extends GetxController {
  final PreferenceService preferenceService;
  final AuthSessionController sessionController;

  SplashController({
    required this.preferenceService,
    required this.sessionController,
  });

  bool _navigated = false;

  @override
  void onReady() {
    super.onReady();
    // If Lottie never finishes (asset fail), still leave splash.
    Future.delayed(const Duration(seconds: 4), goNext);
  }

  void goNext() {
    if (_navigated) return;
    _navigated = true;
    _decideNextRoute();
  }

  Future<void> _decideNextRoute() async {
    try {
      final hasSeenOnboarding =
          preferenceService.getBool(StorageKeys.hasSeenOnboarding);

      if (!hasSeenOnboarding) {
        Get.offAllNamed(AppRoutes.onboarding);
        return;
      }

      final hasSession = await sessionController.hasValidSession();
      if (hasSession) {
        if (Get.isRegistered<SubscriptionAccessController>()) {
          final userId = await Get.find<StorageService>().read(StorageKeys.userId);
          if (userId != null && userId.isNotEmpty) {
            await SubscriptionAccessController.to.identifyUser(userId);
          } else {
            await SubscriptionAccessController.to.syncFromStore();
          }
        }
        Get.offAllNamed(AppRoutes.main);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e, stack) {
      print('SPLASH NAVIGATION ERROR: $e');
      print(stack);
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
