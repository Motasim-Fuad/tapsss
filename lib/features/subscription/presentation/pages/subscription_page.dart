import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../controllers/subscription_access_controller.dart';
import '../controllers/subscription_controller.dart';

class SubscriptionPage extends GetView<SubscriptionController> {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        actions: [
          TextButton(
            onPressed: controller.restorePurchases,
            child: Text('Restore Purchases'.tr),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              _heroCard(context),
              const SizedBox(height: 20),
              if (!controller.isPremium.value) ...[
                Text('Choose your plan'.tr, style: AppTextStyles.h3),
                const SizedBox(height: 12),
                if (controller.isLoading.value)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (controller.plans.isEmpty)
                  _emptyPlans()
                else
                  ...controller.plans.map(
                    (plan) => _PlanTile(
                      plan: plan,
                      isSelected:
                          controller.selectedPlanId.value == plan.id,
                      onTap: () => controller.selectPlan(plan.id),
                    ),
                  ),
                const SizedBox(height: 18),
              ] else ...[
                _activeStatus(controller),
                const SizedBox(height: 18),
              ],
              Text('Premium Includes'.tr, style: AppTextStyles.h3),
              const SizedBox(height: 10),
              ..._features.map((f) => _FeatureRow(text: f)),
              const SizedBox(height: 24),
              if (!controller.isPremium.value && controller.plans.isNotEmpty)
                CustomButton(
                  text: controller.isPurchasing.value
                      ? 'Processing...'.tr
                      : 'Unlock Premium'.tr,
                  icon: Icons.bolt,
                  onPressed: controller.isPurchasing.value
                      ? null
                      : controller.unlockPremium,
                ),
              const SizedBox(height: 10),
              Text(
                'Subscriptions auto-renew. Cancel anytime in your profile.'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.dashboardCardGradient,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.bolt,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Premium Membership'.tr,
            textAlign: TextAlign.center,
            style: AppTextStyles.h2.copyWith(
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pass With Confidence'.tr,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary.copyWith(
              color: AppColors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Unlock premium study materials, 10 realistic mock exams, and advanced analytics'
                .tr,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.white70,
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 390;

              final stats = [
                ('93%', 'Pass Rate'.tr),
                ('3x', 'More Study Time'.tr),
                ('8.4/10', 'Readiness Score'.tr),
                ('50K+', 'Students'.tr),
              ];

              return Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                spacing: narrow ? 18 : 4,
                runSpacing: 14,
                children: stats
                    .map(
                      (item) => SizedBox(
                        width: narrow
                            ? (constraints.maxWidth - 18) / 2
                            : constraints.maxWidth / 4 - 2,
                        child: _StatColumn(
                          value: item.$1,
                          label: item.$2,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _activeStatus(SubscriptionController controller) {
    final access = SubscriptionAccessController.to;
    final expires = access.expirationDate.value;
    String subtitle = 'Your Tapass Pro access is active.'.tr;
    if (expires != null) {
      final date =
          '${expires.year}-${expires.month.toString().padLeft(2, '0')}-${expires.day.toString().padLeft(2, '0')}';
      subtitle = 'Renews or expires on @date'.trParams({'date': date});
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.success.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Premium active'.tr, style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTextStyles.body),
        ],
      ),
    );
  }

  Widget _emptyPlans() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        'No subscription plans are available right now.'.tr,
        textAlign: TextAlign.center,
        style: AppTextStyles.body,
      ),
    );
  }

  List<String> get _features => [
        'Full Study Materials Library'.tr,
        'All 10 Mock Exams'.tr,
        'Unlimited Practice Sessions'.tr,
        'Advanced Progress Analytics'.tr,
        'Bookmarks & Saved Notes'.tr,
        'Priority Support'.tr,
      ];
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;

  const _StatColumn({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: AppTextStyles.h3.copyWith(
            color: AppColors.white,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.white70,
          ),
        ),
      ],
    );
  }
}

class _PlanTile extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanTile({
    required this.plan,
    required this.isSelected,
    required this.onTap,
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
          color: isSelected
              ? AppColors.primary.withOpacity(0.06)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textHint,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.label.tr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label,
                  ),
                  if (plan.badge != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          plan.badge!.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 10,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                plan.price,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.label.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;

  const _FeatureRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            size: 18,
            color: AppColors.success,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              softWrap: true,
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}
