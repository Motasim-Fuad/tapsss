import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/shimmar_widgets.dart';
import '../controllers/faq_controller.dart';

class FaqPage extends GetView<FaqController> {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('FAQ'.tr, style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.faqs.isEmpty) {
          return ShimmerWidget.list();
        }
        if (controller.errorMessage.value != null && controller.faqs.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.wifi_off,
            message: controller.errorMessage.value!,
            actionText: 'Retry'.tr,
            onAction: controller.fetchFaqs,
          );
        }
        if (controller.faqs.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.help_outline,
            message: 'No FAQs available yet'.tr,
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchFaqs,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: controller.faqs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final faq = controller.faqs[index];
              return Card(
                color: AppColors.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    title: Text(faq.question, style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(faq.answer, style: AppTextStyles.bodySecondary),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
