import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/inline_error_widget.dart';
import '../controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

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
              Text('Welcome Back!'.tr, style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'Sign in with your email and password or social media to continue'.tr,
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 28),
              Obx(() => InlineErrorWidget(message: controller.errorMessage.value)),
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Row(
                        children: [
                          Checkbox(
                            value: controller.rememberMe.value,
                            activeColor: AppColors.primary,
                            onChanged: (v) => controller.rememberMe.value = v ?? false,
                          ),
                          Text('Remember me'.tr, style: AppTextStyles.caption),
                        ],
                      )),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                    child: Text('Forgot password?'.tr,
                        style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() => CustomButton(
                    text: 'Log in'.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.login,
                  )),
              const SizedBox(height: 24),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialIconButton(
                        icon: Icons.g_mobiledata,
                        onTap: controller.isLoading.value
                            ? null
                            : controller.loginWithGoogle,
                      ),
                      const SizedBox(width: 16),
                      _SocialIconButton(
                        icon: Icons.apple,
                        onTap: controller.isLoading.value
                            ? null
                            : controller.loginWithApple,
                      ),
                    ],
                  )),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.signup),
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.body,
                      children: [
                        TextSpan(text: "Don't have account? ".tr),
                        TextSpan(
                          text: 'Sign up'.tr,
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

class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _SocialIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}
