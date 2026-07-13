import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../controllers/test_detail_controller.dart';

class TestDetailPage extends GetView<TestDetailController> {
  const TestDetailPage({super.key});

  static const _rules = [
    'The test consists of multiple-choice questions',
    'You have a fixed duration to complete the test',
    'Each question has exactly one correct answer',
    'You can flag questions to review later',
    'You cannot pause the timer once started',
    'Results are displayed immediately upon completion',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Obx(() => Text(controller.testDetail.value?.testName ?? 'Test', style: AppTextStyles.h3)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.testDetail.value == null) {
          return const LoadingWidget();
        }

        final test = controller.testDetail.value;
        if (test == null) {
          return Center(
            child: Text(controller.errorMessage.value ?? 'Unable to load test',
                style: AppTextStyles.bodySecondary),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppColors.dashboardCardGradient),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mock Exam', style: AppTextStyles.caption.copyWith(color: AppColors.white70)),
                    Text(test.testName, style: AppTextStyles.h1.copyWith(color: AppColors.white)),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _StatBox(icon: Icons.track_changes, value: '${test.totalQuestions}', label: 'Questions'),
                        const SizedBox(width: 10),
                        _StatBox(icon: Icons.access_time, value: '${test.durationMinutes}m', label: 'Duration'),
                        const SizedBox(width: 10),
                        _StatBox(icon: Icons.flash_on, value: '${test.passingPercentage}%', label: 'Passing'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       const Text('Exam Rules', style: AppTextStyles.h3),
                        const SizedBox(height: 12),
                        ..._rules.asMap().entries.map((entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: AppColors.primary.withOpacity(0.1),
                                    child: Text('${entry.key + 1}',
                                        style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(entry.value, style: AppTextStyles.body)),
                                ],
                              ),
                            )),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.warningBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                               Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                               SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Ensure you have a stable internet connection before starting. The timer will not pause.',
                                  style: AppTextStyles.caption,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Start Exam Now',
                icon: Icons.flash_on,
                onPressed: controller.startExam,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatBox({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.white, size: 18),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.h2.copyWith(color: AppColors.accent)),
            Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.white70)),
          ],
        ),
      ),
    );
  }
}
