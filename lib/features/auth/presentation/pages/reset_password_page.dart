import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/inline_error_widget.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordPage extends GetView<ResetPasswordController> {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isSuccess.value) {
          return _buildSuccessState();
        }
        return _buildFormState();
      }),
    );
  }

  Widget _buildSuccessState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.check, color: AppColors.white, size: 40),
          ),
          const SizedBox(height: 20),
          Text('Success!', style: AppTextStyles.h1),
          const SizedBox(height: 8),
          Text(
            'Your password has been changed. Please login again with new password.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Back to Login',
            icon: Icons.arrow_forward,
            onPressed: () => Get.offAllNamed(AppRoutes.login),
          ),
        ],
      ),
    );
  }

  Widget _buildFormState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Create New Password', style: AppTextStyles.h1),
          const SizedBox(height: 8),
          Text(
            'Please enter a new password to change',
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 28),
          Obx(() => InlineErrorWidget(message: controller.errorMessage.value)),
          CustomTextField(
            controller: controller.passwordController,
            label: 'New Password',
            hint: 'Password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: controller.confirmPasswordController,
            label: 'Confirm Password',
            hint: 'Password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
          ),
          const SizedBox(height: 20),
          Obx(() => CustomButton(
                text: 'Create New Password',
                icon: Icons.arrow_forward,
                isLoading: controller.isLoading.value,
                onPressed: controller.submit,
              )),
        ],
      ),
    );
  }
}
