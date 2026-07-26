import 'package:arashmati_app/shared/widgets/shimmar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../data/models/test_list_model.dart';
import '../controllers/test_list_controller.dart';

class TestListPage extends GetView<TestListController> {
  const TestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Practice Tests'.tr, style: AppTextStyles.h2),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.testList.value == null) {
          return  ShimmerWidget.list();
        }

        if (controller.errorMessage.value != null && controller.testList.value == null) {
          return EmptyStateWidget(
            icon: Icons.wifi_off,
            message: controller.errorMessage.value!,
            actionText: 'Retry'.tr,
            onAction: controller.fetchTests,
          );
        }

        final data = controller.testList.value;
        if (data == null) return const SizedBox.shrink();

        return RefreshIndicator(
          onRefresh: controller.fetchTests,
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
                    _OverviewStat(
                      value: '${data.overview.completedCount}/${data.overview.totalTests}',
                      label: 'Completed'.tr,
                    ),
                    _OverviewStat(value: '${data.overview.bestScore ?? 0}%', label: 'Best Result'.tr),
                    _OverviewStat(value: '${data.overview.avgScore ?? 0}%', label: 'Avg Score'.tr),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ...data.tests.map((test) => _TestCard(
                    test: test,
                    onTap: () => controller.openTest(test.testNumber),
                  )),
            ],
          ),
        );
      }),
    );
  }
}

class _OverviewStat extends StatelessWidget {
  final String value;
  final String label;

  const _OverviewStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTextStyles.h2.copyWith(color: AppColors.warning)),
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
        ],
      ),
    );
  }
}

class _TestCard extends StatelessWidget {
  final TestListItemModel test;
  final VoidCallback onTap;

  const _TestCard({required this.test, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  test.testNumber.toString().padLeft(2, '0'),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(test.testName, style: AppTextStyles.label),
                    Text(
                      '@questions questions  •  @minutes min'.trParams({
                        'questions': '${test.totalQuestions}',
                        'minutes': '${test.durationMinutes}',
                      }),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              if (test.isCompleted)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${test.bestScore ?? 0}%',
                        style: AppTextStyles.label.copyWith(
                          color: test.passed ? AppColors.success : AppColors.error,
                        )),
                    Text(test.passed ? 'Passed'.tr : 'Failed'.tr, style: AppTextStyles.caption),
                  ],
                ),
            ],
          ),
          if (test.isCompleted) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (test.bestScore ?? 0) / 100,
                minHeight: 5,
                backgroundColor: AppColors.border,
                color: test.passed ? AppColors.success : AppColors.error,
              ),
            ),
          ],
          const SizedBox(height: 12),
          CustomButton(
            text: test.action.tr,
            isOutlined: test.isCompleted,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
