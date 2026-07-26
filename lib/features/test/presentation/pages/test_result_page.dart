import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../controllers/test_result_controller.dart';

class TestResultPage extends GetView<TestResultController> {
  const TestResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final result = controller.testResult;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Test Result'.tr, style: AppTextStyles.h3),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            CircularPercentIndicator(
              radius: 90,
              lineWidth: 14,
              percent: (result.score / 100).clamp(0, 1),
              animation: true,
              progressColor: AppColors.success,
              backgroundColor: AppColors.border,
              circularStrokeCap: CircularStrokeCap.round,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${result.score}%',
                      style: AppTextStyles.h1.copyWith(fontSize: 30)),
                  Text('/100', style: AppTextStyles.bodySecondary),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.infoBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(controller.readinessLabel,
                  style: AppTextStyles.label.copyWith(color: AppColors.info)),
            ),
            const SizedBox(height: 6),
            Text(result.testName, style: AppTextStyles.bodySecondary),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _ResultStat(
                    value: '${result.correctCount}/${result.totalQuestions}',
                    label: 'Correct Answers'.tr,
                    bg: AppColors.successBg,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ResultStat(
                    value: '${result.incorrectCount}/${result.totalQuestions}',
                    label: 'Incorrect'.tr,
                    bg: AppColors.errorBg,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ResultStat(
                    value: '${result.accuracyRate}%',
                    label: 'Accuracy Rate'.tr,
                    bg: AppColors.infoBg,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ResultStat(
                    value: result.timeTakenFormatted,
                    label: 'Time Taken'.tr,
                    bg: AppColors.warningBg,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const Spacer(),
            CustomButton(text: 'Retake Test'.tr, onPressed: controller.retakeTest),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Review Answers'.tr,
              isOutlined: true,
              onPressed: controller.reviewAllAnswers,
            ),
            const SizedBox(height: 10),
            CustomButton(text: 'Done'.tr, onPressed: controller.completeExam),
          ],
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String value;
  final String label;
  final Color bg;
  final Color color;

  const _ResultStat({required this.value, required this.label, required this.bg, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTextStyles.h3.copyWith(color: color)),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
