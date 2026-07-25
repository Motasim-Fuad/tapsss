import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../data/models/submit_test_model.dart';
import '../controllers/review_answers_controller.dart';
import '../../../../config/routes/app_routes.dart';

class ReviewAnswersPage extends GetView<ReviewAnswersController> {
  const ReviewAnswersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Text('Review Answers', style: AppTextStyles.h3),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('See Result', style: AppTextStyles.label.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryChip(
                    value: '${controller.correctCount}',
                    label: 'Correct',
                    bg: AppColors.successBg,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryChip(
                    value: '${controller.incorrectCount}',
                    label: 'Incorrect',
                    bg: AppColors.errorBg,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: controller.reviewAnswers.length,
              itemBuilder: (context, index) {
                return ReviewCard(answer: controller.reviewAnswers[index], index: index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String value;
  final String label;
  final Color bg;
  final Color color;

  const _SummaryChip({required this.value, required this.label, required this.bg, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(value, style: AppTextStyles.h2.copyWith(color: color)),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}


class ReviewCard extends StatelessWidget {
  final ReviewAnswerModel answer;
  final int index;

  const ReviewCard({super.key, required this.answer, required this.index});

  @override
  Widget build(BuildContext context) {
    final selected = answer.selectedAnswer;
    final bg = answer.isCorrect
        ? AppColors.successBg
        : (selected == null ? AppColors.warningBg : AppColors.errorBg);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Q$index. ${answer.questionText}',
                    style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w700)),
              ),
              Icon(
                answer.isCorrect
                    ? Icons.check_circle
                    : (selected == null ? Icons.error_outline : Icons.cancel),
                color: answer.isCorrect
                    ? AppColors.success
                    : (selected == null ? AppColors.warning : AppColors.error),
                size: 20,
              ),
            ],
          ),
          if (answer.image != null) ...[
            const SizedBox(height: 8),
            AppNetworkImage(url: answer.image, width: double.infinity, height: 120),
          ],
          const SizedBox(height: 8),
          Text(
            'Correct: ${answer.options[answer.correctAnswer] ?? answer.correctAnswer}',
            style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
          ),
          if (!answer.isCorrect && selected != null)
            Text(
              'Your answer: ${answer.options[selected] ?? selected}',
              style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          if (selected == null)
            Text('Not answered', style: AppTextStyles.caption.copyWith(color: AppColors.warning)),
          if (!answer.isCorrect && answer.topic != null) ...[
            const SizedBox(height: 10),
            InkWell(
              onTap: () => Get.toNamed(
                AppRoutes.chapterDetail,
                arguments: {'chapterId': answer.topic!.chapterId},
              ),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.menu_book_outlined, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      answer.topic!.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
