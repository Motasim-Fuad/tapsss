import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';

class OtpController extends GetxController {
  final AuthRepository authRepository;

  OtpController({required this.authRepository});

  late final String email;
  late final String mode; // 'register' or 'forgot'

  final otpController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    email = args['email']?.toString() ?? '';
    mode = args['mode']?.toString() ?? 'register';
  }

  Future<void> verify() async {
    errorMessage.value = null;
    final otp = otpController.text.trim();

    if (otp.isEmpty || otp.length < 4) {
      errorMessage.value = 'Please enter a valid verification code'.tr;
      return;
    }

    isLoading.value = true;
    try {
      if (mode == 'register') {
        await authRepository.verifyOtp(email: email, otp: otp);
        Get.offAllNamed(AppRoutes.login);
      } else {
        final result = await authRepository.verifyForgotPasswordOtp(email: email, otp: otp);
        Get.toNamed(
          AppRoutes.resetPassword,
          arguments: {'resetToken': result['resetToken'] ?? '', 'email': email},
        );
      }
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendCode() async {
    errorMessage.value = null;
    try {
      if (mode == 'forgot') {
        await authRepository.forgotPassword(email: email);
      }
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Failed to resend code'.tr;
    }
  }

  // @override
  // void onClose() {
  //   otpController.dispose();
  //   super.onClose();
  // }
}
