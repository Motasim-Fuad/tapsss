import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/error/exceptions.dart';
import '../../../auth/presentation/controllers/auth_session_controller.dart';
import '../../data/models/profile_model.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  final ProfileRepository profileRepository;
  final AuthSessionController sessionController;

  ProfileController({required this.profileRepository, required this.sessionController});

  final Rxn<ProfileModel> profile = Rxn<ProfileModel>();
  final RxBool isLoading = false.obs;
  final RxBool isLoggingOut = false.obs;
  final RxBool isDeletingAccount = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      profile.value = await profileRepository.getProfile();
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  void goToEditProfile() {
    Get.toNamed(AppRoutes.editProfile, arguments: {'profile': profile.value})
        ?.then((_) => fetchProfile());
  }

  Future<void> logout() async {
    isLoggingOut.value = true;
    await sessionController.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> confirmDeleteAccount() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Delete Account'.tr),
        content: Text(
          'This will permanently delete your account and all associated data. This cannot be undone.'.tr,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel'.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Delete'.tr,
              style: const TextStyle(color: Color(0xFFF04438)),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await deleteAccount();
    }
  }

  Future<void> deleteAccount() async {
    isDeletingAccount.value = true;
    try {
      await profileRepository.deleteAccount();
      await sessionController.logout();
      Get.offAllNamed(AppRoutes.login);
    } on ApiException catch (e) {
      Get.snackbar('Error'.tr, e.message);
    } catch (_) {
      Get.snackbar('Error'.tr, 'Something went wrong. Please try again.'.tr);
    } finally {
      isDeletingAccount.value = false;
    }
  }
}
