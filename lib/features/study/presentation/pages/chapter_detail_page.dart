import 'package:arashmati_app/shared/widgets/shimmar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/inline_error_widget.dart';
import '../controllers/chapter_detail_controller.dart';

class ChapterDetailPage extends GetView<ChapterDetailController> {
  const ChapterDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.chapter.value == null) {
          return ShimmerWidget.list();
        }

        final chapter = controller.chapter.value;
        if (chapter == null || chapter.lessons.isEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value ?? 'No lessons available',
              style: AppTextStyles.bodySecondary,
            ),
          );
        }

        final lesson = chapter.lessons[controller.currentLessonIndex.value];
        final totalLessons = chapter.lessons.length;
        final currentLessonNumber = controller.currentLessonIndex.value + 1;

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lesson $currentLessonNumber of $totalLessons',
                        style: AppTextStyles.caption,
                      ),
                      // Text(
                      //   '${((currentLessonNumber / totalLessons) * 100).round()}%',
                      //   style: AppTextStyles.caption,
                      // ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: currentLessonNumber / totalLessons,
                      minHeight: 5,
                      backgroundColor: AppColors.border,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppNetworkImage(url: lesson.lessonImage, width: double.infinity, height: 180),

                  const SizedBox(height: 16),
                  Text(chapter.title, style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Text(lesson.heading, style: AppTextStyles.h1),
                  const SizedBox(height: 16),
                  ...lesson.paragraphs.map(
                        (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(p.content, style: AppTextStyles.body.copyWith(height: 1.5)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Obx(() => InlineErrorWidget(message: controller.errorMessage.value)),
                  Row(
                    children: [
                      if (!controller.isFirstLesson) ...[
                        Expanded(
                          child: CustomButton(
                            text: 'Previous',
                            isOutlined: true,
                            onPressed: controller.previousLesson,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: CustomButton(
                          text: controller.isLastLesson ? 'Mark Complete' : 'Next',
                          icon: controller.isLastLesson ? null : Icons.arrow_forward,
                          isLoading: controller.isMarking.value,
                          onPressed: controller.nextLesson,
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
    );
  }
}