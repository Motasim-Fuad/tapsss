import 'package:arashmati_app/features/notification/presentation/controllers/notification_controller.dart';
import 'package:get/get.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/revenuecat_service.dart';
import '../../../subscription/presentation/controllers/subscription_access_controller.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/services/social_auth_service.dart';

class AuthSessionController extends GetxController {
  final AuthRepository authRepository;
  final StorageService storageService;

  AuthSessionController({required this.authRepository, required this.storageService});

  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxBool isLoggedIn = false.obs;

  Future<void> saveSession(LoginResponseModel data) async {
    await storageService.write(StorageKeys.accessToken, data.accessToken);
    await storageService.write(StorageKeys.refreshToken, data.refreshToken);
    await storageService.write(StorageKeys.userId, data.user.id);
    await storageService.write(StorageKeys.userName, data.user.name);
    await storageService.write(StorageKeys.userEmail, data.user.email);
    currentUser.value = data.user;
    isLoggedIn.value = true;

    if (Get.isRegistered<SubscriptionAccessController>()) {
      await SubscriptionAccessController.to.identifyUser(data.user.id);
    } else {
      try {
        await RevenueCatService.logIn(data.user.id);
      } catch (e) {
        print('[RevenueCat] login failed: $e');
      }
    }
  }

  void updateUser(UserModel user) {
    currentUser.value = user;
  }

  Future<bool> hasValidSession() async {
    final token = await storageService.read(StorageKeys.accessToken);
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    try {

      await authRepository.logout();
    } catch (_) {}
    await NotificationController.to.clear();
    await SocialAuthService.instance.signOut();
    await storageService.deleteAll();
    if (Get.isRegistered<SubscriptionAccessController>()) {
      await SubscriptionAccessController.to.clearUser();
    } else {
      try {
        await RevenueCatService.logOut();
      } catch (e) {
        print('[RevenueCat] logout failed: $e');
      }
    }
    currentUser.value = null;
    isLoggedIn.value = false;
  }
}
