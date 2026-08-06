import 'package:arashmati_app/features/notification/presentation/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_session_controller.dart';

class LoginController extends GetxController {
  final AuthRepository authRepository;
  final AuthSessionController sessionController;

  LoginController({required this.authRepository, required this.sessionController});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool rememberMe = false.obs;
  final RxnString errorMessage = RxnString();

  Future<void> login() async {
    errorMessage.value = null;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please enter both email and password'.tr;
      return;
    }

    isLoading.value = true;
    try {
      final response = await authRepository.login(email: email, password: password);
      await sessionController.saveSession(response);
      await NotificationController.to.register();
      Get.offAllNamed(AppRoutes.main);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.onClose();
  // }
}
