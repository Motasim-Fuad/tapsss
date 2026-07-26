import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/exceptions.dart';
import '../../../auth/presentation/controllers/auth_session_controller.dart';
import '../../data/models/profile_model.dart';
import '../../domain/repositories/profile_repository.dart';

class EditProfileController extends GetxController {
  final ProfileRepository profileRepository;
  final AuthSessionController sessionController;

  EditProfileController({required this.profileRepository, required this.sessionController});

  late final TextEditingController nameController;
  final RxnString pickedImagePath = RxnString();
  final Rxn<ProfileModel> existingProfile = Rxn<ProfileModel>();

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final profile = args['profile'] as ProfileModel?;
    existingProfile.value = profile;
    nameController = TextEditingController(text: profile?.name ?? '');
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      pickedImagePath.value = image.path;
    }
  }

  Future<void> save() async {
    errorMessage.value = null;
    final name = nameController.text.trim();

    if (name.isEmpty) {
      errorMessage.value = 'Please enter your full name'.tr;
      return;
    }

    isLoading.value = true;
    try {
      final updated = await profileRepository.updateProfile(
        name: name,
        imagePath: pickedImagePath.value,
      );
      sessionController.updateUser(sessionController.currentUser.value!.copyWith(
        name: updated.name,
        profilePic: updated.profilePic,
      ));
      Get.back();
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
