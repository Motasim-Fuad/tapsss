import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/inline_error_widget.dart';
import '../../../../shared/widgets/otp_input_field.dart';
import '../controllers/otp_controller.dart';

class OtpVerificationPage extends GetView<OtpController> {
  const OtpVerificationPage({super.key});

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
            Text('Verify your Email'.tr, style: AppTextStyles.h1),
            const SizedBox(height: 8),
            Text(
              'Please enter the 6 digit verification code that we have been sent to your email address'.tr,
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: 28),
            Obx(() => InlineErrorWidget(message: controller.errorMessage.value)),
            OtpInputField(
              controller: controller.otpController,
              length: 6,
              onCompleted: (_) => controller.verify(),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: controller.resendCode,
                child: Text("Don't receive code? Resend code".tr,
                    style: AppTextStyles.caption.copyWith(color: AppColors.error)),
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => CustomButton(
              text: 'Next'.tr,
              icon: Icons.arrow_forward,
              isLoading: controller.isLoading.value,
              onPressed: controller.verify,
            )),
          ],
        ),
      ),
    );
  }
}