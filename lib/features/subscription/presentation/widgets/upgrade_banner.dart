import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../controllers/subscription_access_controller.dart';

class UpgradeBanner extends StatelessWidget {
  const UpgradeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SubscriptionAccessController>()) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      final access = SubscriptionAccessController.to;
      if (access.isPremium.value) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: InkWell(
          onTap: access.openPaywall,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.warningBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accent.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_outline, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Free plan: 1 chapter and 1 mock exam. Unlock Premium for full access.'
                        .tr,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Upgrade'.tr,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
