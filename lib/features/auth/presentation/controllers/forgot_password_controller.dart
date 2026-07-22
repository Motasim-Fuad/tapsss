import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository authRepository;

  ForgotPasswordController({required this.authRepository});

  final emailController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  Future<void> submit() async {
    errorMessage.value = null;
    final email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      errorMessage.value = 'Please enter a valid email address';
      return;
    }

    isLoading.value = true;
    try {
      await authRepository.forgotPassword(email: email);
      Get.toNamed(AppRoutes.verifyForgotOtp, arguments: {'email': email, 'mode': 'forgot'});
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   super.onClose();
  // }
}
