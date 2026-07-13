import 'package:get/get.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../controllers/login_controller.dart';
import '../controllers/signup_controller.dart';
import '../controllers/otp_controller.dart';
import '../controllers/forgot_password_controller.dart';
import '../controllers/reset_password_controller.dart';
import '../controllers/auth_session_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(
        () => AuthRepositoryImpl(AuthRemoteDataSource(Get.find())),
        fenix: true,
      );
    }
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(
          authRepository: Get.find(),
          sessionController: Get.find<AuthSessionController>(),
        ));
  }
}

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignupController(authRepository: Get.find()));
  }
}

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtpController(authRepository: Get.find()));
  }
}

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordController(authRepository: Get.find()));
  }
}

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPasswordController(authRepository: Get.find()));
  }
}
