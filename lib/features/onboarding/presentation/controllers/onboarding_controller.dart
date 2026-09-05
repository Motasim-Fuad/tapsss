import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/preference_service.dart';

class OnboardingSlide {
  final String title;
  final String description;

  OnboardingSlide({
    required this.title,
    required this.description,
  });
}

class OnboardingController extends GetxController {
  final PreferenceService preferenceService;

  OnboardingController({
    required this.preferenceService,
  });

  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<String> images = [
    'assets/images/onboarding1.png',
    'assets/images/onboarding2.png',
    'assets/images/onboarding3.png',
  ];

  final List<OnboardingSlide> slides = [
    OnboardingSlide(
      title: 'Prepare for Your Swedish Citizenship Journey'.tr,
      description:
      'Your trusted companion for the Swedish Citizenship Language Test. Structured lessons, practice exams, and personalized progress tracking — all in one premium platform.'.tr,
    ),
    OnboardingSlide(
      title: 'Expert-Crafted Study Materials'.tr,
      description:
      'Comprehensive curriculum covering all Swedish language competencies required for citizenship. Learn at your own pace with beautifully structured lessons and interactive content.'.tr,
    ),
    OnboardingSlide(
      title: 'Join 50,000+ Successful Applicants'.tr,
      description:
      'Thousands of immigrants have passed their Swedish citizenship test with SwedishPass. Your journey to becoming a Swedish citizen starts here.'.tr,
    ),
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  Future<void> next() async {
    if (currentPage.value < slides.length - 1) {
      await pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    await preferenceService.setBool(
      StorageKeys.hasSeenOnboarding,
      true,
    );

    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}