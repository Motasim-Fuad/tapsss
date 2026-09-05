import 'package:arashmati_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:arashmati_app/shared/widgets/shimmar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../subscription/presentation/controllers/subscription_access_controller.dart';
import '../../../subscription/presentation/widgets/premium_lock_badge.dart';
import '../../data/models/dashboard_model.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController= Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Obx(() {
          SubscriptionAccessController.to.isPremium.value;
          if (controller.isLoading.value && controller.dashboard.value == null) {
            return  ShimmerWidget.list();
          }

          if (controller.errorMessage.value != null && controller.dashboard.value == null) {
            return EmptyStateWidget(
              icon: Icons.wifi_off,
              message: controller.errorMessage.value!,
              actionText: 'Retry'.tr,
              onAction: controller.fetchDashboard,
            );
          }

          final data = controller.dashboard.value;
          if (data == null) return const SizedBox.shrink();

          return RefreshIndicator(
            onRefresh: controller.fetchDashboard,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome,'.tr, style: AppTextStyles.body),
                        Row(
                          children: [
                            Obx(() => Text(
                              profileController.profile.value?.name??"",
                                  style: AppTextStyles.h2,
                                )),
                            const SizedBox(width: 5,),
                            Text("👋",style: TextStyle(fontSize: 30),),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.notifications_none, color: AppColors.textPrimary),
                        const SizedBox(width: 12),
                        Obx(() {
                          final pic =  profileController.profile.value?.profilePic;
                          return CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.surface,
                            child: pic == null || pic.isEmpty
                                ? const Icon(Icons.person, color: AppColors.textHint)
                                : ClipOval(
                                    child: AppNetworkImage(url: pic, width: 36, height: 36),
                                  ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _ExamReadinessCard(data: data),
                const SizedBox(height: 24),
               Text('Study Topics'.tr, style: AppTextStyles.h3),
                const SizedBox(height: 12),

                SizedBox(
                  height: 170,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.studyTopics.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final topic = data.studyTopics[index];

                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 3.4,
                        child: _StudyTopicCard(
                          image: topic.coverImage,
                          title: topic.title,
                          totalLessons: topic.totalLessons,
                          isLocked: !SubscriptionAccessController.to
                              .canAccessChapter(topic.chapterNumber),
                          onTap: () => controller.openChapter(topic),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text('Recent Activity'.tr, style: AppTextStyles.h3),
                const SizedBox(height: 12),
                if (data.recentActivity.isEmpty)
                 Text('No recent activity yet'.tr, style: AppTextStyles.bodySecondary)
                else
                  ...data.recentActivity.map((activity) => _RecentActivityTile(activity: activity)),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.infoBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.trending_up, size: 16, color: AppColors.info),
                          const SizedBox(width: 6),
                          Text('SWEDISH FACT OF THE DAY'.tr,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.info,
                                fontWeight: FontWeight.w700,
                              )),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sweden became a member of the European Union on January 1, 1995. Swedish citizens enjoy full freedom of movement across EU member states.'.tr,
                        style: AppTextStyles.bodySecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
class _ExamReadinessCard extends StatelessWidget {
  final DashboardModel data;

  const _ExamReadinessCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 7,
            spreadRadius: -4,
            offset: Offset(0, 7),
          ),
        ],
      ),
            child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.8,
                child: Image.asset(
                  "assets/images/pexels-janzidlicky-3030468.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.dashboardCardGradient[0].withOpacity(0.98),
                      AppColors.dashboardCardGradient[1].withOpacity(0.70),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          data.examStatus,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Exam Readiness Score'.tr,
                              style: AppTextStyles.bodySecondary.copyWith(
                                color: AppColors.white70,
                              ),
                            ),
                            Text(
                              '${data.examReadinessScore}/100',
                              style: AppTextStyles.h1.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "You're making great progress! Keep it up to reach exam readiness.".tr,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircularPercentIndicator(
                        radius: 42,
                        lineWidth: 7,
                        percent:
                        (data.examReadinessScore / 100).clamp(0, 1),
                        animation: true,
                        progressColor: AppColors.accent,
                        backgroundColor:
                        AppColors.white.withOpacity(0.2),
                        center: Text(
                          '${data.examReadinessScore}%',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _StatChip(
                          label: 'Tests Done'.tr,
                          value:
                          '${data.testsDone}/${data.totalTests}',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatChip(
                          label: 'Streak'.tr,
                          value: '${data.streak}d 🔥',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(value, style: AppTextStyles.h3.copyWith(color: AppColors.white)),
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.white70)),
        ],
      ),
    );
  }
}

class _StudyTopicCard extends StatelessWidget {
  final String title;
  final int totalLessons;
  final VoidCallback onTap;
  final String image;
  final bool isLocked;

  const _StudyTopicCard({
    required this.image,
    required this.title,
    required this.totalLessons,
    required this.onTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 36,
                  width: 36,
                  child: Image.network(
                    image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label,
                ),
                const SizedBox(height: 6),
                Text(
                  '$totalLessons Lessons',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            if (isLocked)
              const Positioned(
                top: 0,
                right: 0,
                child: PremiumLockBadge(size: 14),
              ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivityTile extends StatelessWidget {
  final RecentActivityModel activity;

  const _RecentActivityTile({required this.activity});

  IconData get _icon {
    switch (activity.type) {
      case 'test_completed':
        return Icons.check_circle_outline;
      case 'streak_achieved':
        return Icons.local_fire_department_outlined;
      default:
        return Icons.bar_chart_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_icon, color: AppColors.success, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: AppTextStyles.label),
                Text(activity.timeAgo, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
