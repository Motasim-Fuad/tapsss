import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.slides.length,
                itemBuilder: (context, index) {
                  final slide = controller.slides[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),

                        Expanded(
                          child: Image.asset(
                            controller.images[index],
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h2,
                        ),

                        const SizedBox(height: 10),

                        Text(
                          slide.description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySecondary,
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),

            Obx(
                  () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.slides.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: controller.currentPage.value == index ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Obx(
                    () => CustomButton(
                  text: controller.currentPage.value == controller.slides.length - 1
                      ? 'Get Started'
                      : 'Continue',
                  icon: Icons.arrow_forward,
                  onPressed: controller.next,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}