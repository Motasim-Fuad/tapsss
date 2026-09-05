import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';

class ResetPasswordController extends GetxController {
  final AuthRepository authRepository;

  ResetPasswordController({required this.authRepository});

  late final String resetToken;

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isSuccess = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    resetToken = args['resetToken']?.toString() ?? '';
  }

  Future<void> submit() async {
    errorMessage.value = null;
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      errorMessage.value = 'Please fill in both fields'.tr;
      return;
    }

    if (password != confirmPassword) {
      errorMessage.value = 'Passwords do not match'.tr;
      return;
    }

    isLoading.value = true;
    try {
      await authRepository.resetPassword(
        resetToken: resetToken,
        newPassword: password,
        confirmNewPassword: confirmPassword,
      );
      isSuccess.value = true;
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.'.tr;
    } finally {
      isLoading.value = false;
    }
  }
}
