import 'package:arashmati_app/shared/widgets/shimmar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/inline_error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../controllers/exam_controller.dart';

class ExamPage extends GetView<ExamController> {
  const ExamPage({super.key});

  Future<bool> _confirmExit() async {
    final result = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(color: AppColors.errorBg, shape: BoxShape.circle),
                child: const Icon(Icons.warning_amber_rounded, color: AppColors.error),
              ),
              const SizedBox(height: 16),
              const Text('Exit Exam?', style: AppTextStyles.h3),
              const SizedBox(height: 8),
             const  Text(
                'Your progress will be lost. Are you sure you want to exit?',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Continue Test',
                      isOutlined: true,
                      onPressed: () => Get.back(result: false),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: CustomButton(
                      text: 'Exit Exam',
                      color: AppColors.error,
                      onPressed: () => Get.back(result: true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmExit()) Get.back();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value && controller.examData.value == null) {
              return  ShimmerWidget.list();
            }

            if (controller.examData.value == null) {
              return Center(
                child: Text(
                  controller.errorMessage.value ?? 'Unable to start test',
                  style: AppTextStyles.bodySecondary,
                ),
              );
            }

            final question = controller.currentQuestion;
            final selected = controller.selectedAnswers[question.id];
            final isFlagged = controller.flaggedQuestionIds.contains(question.id);
            final isBookmarked = controller.bookmarkedQuestionIds.contains(question.id);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      _RoundIconButton(
                        icon: Icons.close,
                        color: AppColors.error,
                        onTap: () async {
                          if (await _confirmExit()) Get.back();
                        },
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: AppColors.textPrimary),
                            const SizedBox(width: 6),
                            Text(controller.formattedTime,
                                style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      _RoundIconButton(
                        icon: isFlagged ? Icons.flag : Icons.flag_outlined,
                        color: isFlagged ? AppColors.warning : AppColors.textSecondary,
                        onTap: controller.toggleFlag,
                      ),
                      const SizedBox(width: 8),
                      _RoundIconButton(
                        icon: isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                        color: isBookmarked ? AppColors.primary : AppColors.textSecondary,
                        onTap: controller.toggleBookmark,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${controller.currentIndex.value + 1} of ${controller.examData.value!.questions.length}',
                            style: AppTextStyles.bodySecondary,
                          ),
                          Text('${(controller.progress * 100).round()}%', style: AppTextStyles.bodySecondary),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: controller.progress,
                          minHeight: 5,
                          backgroundColor: AppColors.border,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (question.image != null) ...[
                                AppNetworkImage(url: question.image, width: double.infinity, height: 160),
                                const SizedBox(height: 12),
                              ],
                              if (question.questionText.isNotEmpty)
                                Text(question.questionText,
                                    style: AppTextStyles.h3.copyWith(height: 1.4)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...question.options.entries.map((entry) {
                          final isSelected = selected == entry.key;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () => controller.selectAnswer(entry.key),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary.withOpacity(0.08) : AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : AppColors.border,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor:
                                          isSelected ? AppColors.primary : AppColors.surface,
                                      child: Text(
                                        entry.key,
                                        style: AppTextStyles.caption.copyWith(
                                          color: isSelected ? AppColors.white : AppColors.textSecondary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text(entry.value, style: AppTextStyles.body)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      InlineErrorWidget(message: controller.errorMessage.value),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Previous',
                              isOutlined: true,
                              onPressed: controller.isFirstQuestion ? null : controller.previousQuestion,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              text: controller.isLastQuestion ? 'Submit' : 'Next',
                              icon: Icons.arrow_forward,
                              isLoading: controller.isSubmitting.value,
                              onPressed:
                                  controller.isLastQuestion ? controller.submitExam : controller.nextQuestion,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
