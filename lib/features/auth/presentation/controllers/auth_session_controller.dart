import 'package:arashmati_app/features/notification/presentation/controllers/notification_controller.dart';
import 'package:get/get.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthSessionController extends GetxController {
  final AuthRepository authRepository;
  final StorageService storageService;

  AuthSessionController({required this.authRepository, required this.storageService});

  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxBool isLoggedIn = false.obs;

  Future<void> saveSession(LoginResponseModel data) async {
    await storageService.write(StorageKeys.accessToken, data.accessToken);
    await storageService.write(StorageKeys.refreshToken, data.refreshToken);
    await storageService.write(StorageKeys.userName, data.user.name);
    await storageService.write(StorageKeys.userEmail, data.user.email);
    currentUser.value = data.user;
    isLoggedIn.value = true;
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
    } catch (_) {
      // ignore network errors on logout, clear local session regardless
    }
    await NotificationController.to.clear();
    await storageService.deleteAll();
    currentUser.value = null;
    isLoggedIn.value = false;
  }
}
