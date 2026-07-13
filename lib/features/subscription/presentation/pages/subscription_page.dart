import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.dashboardCardGradient),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.bolt, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 12),
                Text('Premium Membership', style: AppTextStyles.h2.copyWith(color: AppColors.white)),
                const SizedBox(height: 4),
                Text('Pass With Confidence',
                    style: AppTextStyles.bodySecondary.copyWith(color: AppColors.white70)),
                Text(
                  'Unlock premium study materials, 10 realistic mock exams, and advanced analytics',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(color: AppColors.white70),
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Expanded(child: _StatColumn(value: '93%', label: 'Pass Rate')),
                    Expanded(child: _StatColumn(value: '3x', label: 'More Study Time')),
                    Expanded(child: _StatColumn(value: '8.4/10', label: 'Readiness Score')),
                    Expanded(child: _StatColumn(value: '50K+', label: 'Students')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Choose your plan', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          Obx(() => Column(
                children: controller.plans
                    .map((plan) => _PlanTile(
                          plan: plan,
                          isSelected: controller.selectedPlanId.value == plan.id,
                          onTap: () => controller.selectPlan(plan.id),
                        ))
                    .toList(),
              )),
          const SizedBox(height: 20),
          Text('Premium Includes', style: AppTextStyles.h3),
          const SizedBox(height: 10),
          ..._features.map((f) => _FeatureRow(text: f)),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Unlock Premium — 999 SEK',
            icon: Icons.bolt,
            onPressed: controller.unlockPremium,
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Subscriptions auto-renew. Cancel anytime in your profile.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }

  static const _features = [
    'Full Study Materials Library',
    'All 10 Mock Exams',
    'Unlimited Practice Sessions',
    'Advanced Progress Analytics',
    'Bookmarks & Saved Notes',
    'Priority Support',
  ];
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;

  const _StatColumn({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.h3.copyWith(color: AppColors.white)),
        Text(label, textAlign: TextAlign.center, style: AppTextStyles.caption.copyWith(color: AppColors.white70)),
      ],
    );
  }
}

class _PlanTile extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanTile({required this.plan, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.06) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.textHint,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.label, style: AppTextStyles.label),
                      if (plan.subLabel != null) Text(plan.subLabel!, style: AppTextStyles.caption),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(plan.price, style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w700)),
                      if (plan.badge != null)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(plan.badge!,
                              style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.primaryDark)),
                        ),
                    ],
                  ),
                ],
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: AppColors.success),
          const SizedBox(width: 8),
          Text(text, style: AppTextStyles.body),
        ],
      ),
    );
  }
}
