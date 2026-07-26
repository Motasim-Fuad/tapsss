import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/inline_error_widget.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordPage extends GetView<ForgotPasswordController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Forgot Password'.tr, style: AppTextStyles.h1),
            const SizedBox(height: 8),
            Text(
              'Select which contact details should we use to reset your password'.tr,
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
            const SizedBox(height: 20),
            Obx(() => CustomButton(
                  text: 'Next'.tr,
                  icon: Icons.arrow_forward,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.submit,
                )),
          ],
        ),
      ),
    );
  }
}
