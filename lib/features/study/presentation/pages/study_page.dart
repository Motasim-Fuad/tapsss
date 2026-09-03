import 'package:arashmati_app/shared/widgets/shimmar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../subscription/presentation/controllers/subscription_access_controller.dart';
import '../../../subscription/presentation/widgets/premium_lock_badge.dart';
import '../../../subscription/presentation/widgets/upgrade_banner.dart';
import '../../data/models/study_materials_model.dart';
import '../controllers/study_controller.dart';

class StudyPage extends GetView<StudyController> {
  const StudyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Study Materials'.tr, style: AppTextStyles.h2),
      ),
      body: Obx(() {
        SubscriptionAccessController.to.isPremium.value;
        if (controller.isLoading.value && controller.materials.value == null) {
          return ShimmerWidget.list();
        }

        if (controller.errorMessage.value != null && controller.materials.value == null) {
          return EmptyStateWidget(
            icon: Icons.wifi_off,
            message: controller.errorMessage.value!,
            actionText: 'Retry'.tr,
            onAction: controller.fetchMaterials,
          );
        }

        final data = controller.materials.value;
        if (data == null) return const SizedBox.shrink();

        return RefreshIndicator(
          onRefresh: controller.fetchMaterials,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppColors.dashboardCardGradient),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircularPercentIndicator(
                      radius: 30,
                      lineWidth: 6,
                      percent: (data.overallProgress.progressPercentage / 100).clamp(0, 1),
                      progressColor: AppColors.accent,
                      backgroundColor: AppColors.white.withOpacity(0.2),
                      center: Text('${data.overallProgress.progressPercentage}%',
                          style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Study Materials'.tr,
                              style: AppTextStyles.h3.copyWith(color: AppColors.white)),
                          Text(
                            '${data.overallProgress.completedLessons}/${data.overallProgress.totalLessons} lessons completed',
                            style: AppTextStyles.caption.copyWith(color: AppColors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const UpgradeBanner(),
              Text('Chapters'.tr, style: AppTextStyles.h3),
              const SizedBox(height: 12),
              ...data.chapters.map((chapter) {
                final locked = !SubscriptionAccessController.to
                    .canAccessChapter(chapter.chapterNumber);
                return _ChapterCard(
                  chapter: chapter,
                  isLocked: locked,
                  onTap: () => controller.openChapter(chapter),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  final ChapterModel chapter;
  final VoidCallback onTap;
  final bool isLocked;

  const _ChapterCard({
    required this.chapter,
    required this.onTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: chapter.isChapterCompleted ? AppColors.success : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              chapter.isChapterCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: chapter.isChapterCompleted ? AppColors.success : AppColors.textHint,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chapter.title, style: AppTextStyles.label),
                  const SizedBox(height: 2),
                  Text(
                    '@count lessons'.trParams({'count': '${chapter.totalLessons}'}),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            if (isLocked)
              const PremiumLockBadge()
            else
              const Icon(Icons.chevron_right, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
