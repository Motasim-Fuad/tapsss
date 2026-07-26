import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/inline_error_widget.dart';
import '../controllers/signup_controller.dart';

class SignupPage extends GetView<SignupController> {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('Register Account'.tr, style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'Sign in with your email and password or social media to continue'.tr,
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 28),
              Obx(() => InlineErrorWidget(message: controller.errorMessage.value)),
              CustomTextField(
                controller: controller.nameController,
                label: 'Full Name'.tr,
                hint: 'Your Name'.tr,
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.emailController,
                label: 'Email'.tr,
                hint: 'you@example.com',
                prefixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.passwordController,
                label: 'Password'.tr,
                hint: '••••••••',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.confirmPasswordController,
                label: 'Confirm Password'.tr,
                hint: '••••••••',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 14),
              Obx(() => Row(
                    children: [
                      Checkbox(
                        value: controller.agreedToTerms.value,
                        activeColor: AppColors.primary,
                        onChanged: (v) => controller.agreedToTerms.value = v ?? false,
                      ),
                      Expanded(
                        child: Text('Agree with terms and privacy'.tr, style: AppTextStyles.caption),
                      ),
                    ],
                  )),
              const SizedBox(height: 8),
              Obx(() => CustomButton(
                    text: 'Sign Up'.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.register,
                  )),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.body,
                      children: [
                        TextSpan(text: 'Already have an account? '.tr),
                        TextSpan(
                          text: 'Sign in'.tr,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
