import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/inline_error_widget.dart';
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
            Text('Verify your Email', style: AppTextStyles.h1),
            const SizedBox(height: 8),
            Text(
              'Please enter the 6 digit verification code that we have been sent to your email address',
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: 28),
            Obx(() => InlineErrorWidget(message: controller.errorMessage.value)),
            TextField(
              controller: controller.otpController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.copyWith(letterSpacing: 12),
              maxLength: 6,
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: controller.resendCode,
                child: Text("Don't receive code? Resend code",
                    style: AppTextStyles.caption.copyWith(color: AppColors.error)),
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => CustomButton(
                  text: 'Next',
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
