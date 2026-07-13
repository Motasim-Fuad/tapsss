import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';

class SignupController extends GetxController {
  final AuthRepository authRepository;

  SignupController({required this.authRepository});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool agreedToTerms = false.obs;
  final RxnString errorMessage = RxnString();

  Future<void> register() async {
    errorMessage.value = null;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      errorMessage.value = 'Please fill in all fields';
      return;
    }

    if (password != confirmPassword) {
      errorMessage.value = 'Passwords do not match';
      return;
    }

    if (!agreedToTerms.value) {
      errorMessage.value = 'Please agree to terms and privacy policy';
      return;
    }

    isLoading.value = true;
    try {
      await authRepository.register(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      Get.toNamed(AppRoutes.verifyOtp, arguments: {'email': email, 'mode': 'register'});
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
