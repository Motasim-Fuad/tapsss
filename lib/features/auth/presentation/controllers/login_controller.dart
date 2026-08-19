import 'dart:async';

import 'package:arashmati_app/features/notification/presentation/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/error/exceptions.dart';
import '../../data/models/login_response_model.dart';
import '../../data/services/social_auth_service.dart';
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
      await _finishLogin(response);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    if (isLoading.value) return;
    errorMessage.value = null;
    isLoading.value = true;
    try {
      final idToken = await SocialAuthService.instance.getGoogleIdToken();
      final response = await authRepository.loginWithGoogle(idToken: idToken);
      await _finishLogin(response);
    } on SocialAuthCancelledException {
      // User closed the Google sheet — stay on login.
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithApple() async {
    if (isLoading.value) return;
    errorMessage.value = null;
    isLoading.value = true;
    try {
      final apple = await SocialAuthService.instance.getAppleCredential();
      final response = await authRepository.loginWithApple(
        identityToken: apple.identityToken,
        email: apple.email,
        givenName: apple.givenName,
        familyName: apple.familyName,
      );
      await _finishLogin(response);
    } on SocialAuthCancelledException {
      // User closed the Apple sheet — stay on login.
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _finishLogin(LoginResponseModel response) async {
    await sessionController.saveSession(response);
    Get.offAllNamed(AppRoutes.main);
    unawaited(NotificationController.to.register());
  }
}
