import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/inline_error_widget.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Text('Edit Profile', style: AppTextStyles.h3),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Obx(() {
                    final pickedPath = controller.pickedImagePath.value;
                    final existingPic = controller.existingProfile.value?.profilePic;

                    return CircleAvatar(
                      radius: 42,
                      backgroundColor: AppColors.surface,
                      child: ClipOval(
                        child: pickedPath != null
                            ? Image.file(File(pickedPath), width: 84, height: 84, fit: BoxFit.cover)
                            : (existingPic == null || existingPic.isEmpty
                                ? const Icon(Icons.person, size: 36, color: AppColors.textHint)
                                : AppNetworkImage(url: existingPic, width: 84, height: 84)),
                      ),
                    );
                  }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: controller.pickImage,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, size: 14, color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Obx(() => InlineErrorWidget(message: controller.errorMessage.value)),
            CustomTextField(
              controller: controller.nameController,
              label: 'Full Name',
              hint: 'Your Name',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _ReadonlyField(label: 'Email', value: controller.existingProfile.value?.email ?? ''),
            const Spacer(),
            Obx(() => CustomButton(
                  text: 'Save Changes',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.save,
                )),
          ],
        ),
      ),
    );
  }
}

class _ReadonlyField extends StatelessWidget {
  final String label;
  final String value;

  const _ReadonlyField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.mail_outline, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 10),
              Text(value, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}
