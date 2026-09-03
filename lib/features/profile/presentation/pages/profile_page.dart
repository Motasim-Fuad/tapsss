import 'package:arashmati_app/shared/widgets/shimmar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/locale_service.dart';
import '../../../../core/utils/legal_links.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../../shared/widgets/asset_placeholder.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../subscription/presentation/controllers/subscription_access_controller.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() {
        SubscriptionAccessController.to.isPremium.value;
        if (controller.isLoading.value && controller.profile.value == null) {
          return ShimmerWidget.list();
        }

        if (controller.errorMessage.value != null && controller.profile.value == null) {
          return EmptyStateWidget(
            icon: Icons.wifi_off,
            message: controller.errorMessage.value!,
            actionText: 'Retry'.tr,
            onAction: controller.fetchProfile,
          );
        }

        final profile = controller.profile.value;
        if (profile == null) return const SizedBox.shrink();

        return RefreshIndicator(
          onRefresh: controller.fetchProfile,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  const Positioned.fill(
                    child:Image(
                        image: AssetImage(
                            "assets/images/pexels-jesschen-32963553.jpg",
                        ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.dashboardCardGradient.first.withOpacity(0.85),
                            AppColors.dashboardCardGradient.last.withOpacity(0.85),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Profile'.tr, style: AppTextStyles.h2.copyWith(color: AppColors.white)),
                            IconButton(
                              icon: const Icon(Icons.chevron_right, color: AppColors.white),
                              onPressed: controller.goToEditProfile,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: AppColors.white.withOpacity(0.2),
                              child: profile.profilePic == null || profile.profilePic!.isEmpty
                                  ? const Icon(Icons.person, color: AppColors.white, size: 28)
                                  : ClipOval(
                                child: AppNetworkImage(
                                  url: profile.profilePic,
                                  width: 56,
                                  height: 56,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profile.name,
                                    style: AppTextStyles.h3.copyWith(color: AppColors.white)),
                                Text(profile.email,
                                    style: AppTextStyles.caption.copyWith(color: AppColors.white70)),
                                const SizedBox(height: 4),
                                Text(
                                  SubscriptionAccessController.to.isPremium.value
                                      ? 'Premium'.tr
                                      : 'Free plan'.tr,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                                child: _StatBox(
                                    value: '${profile.testStats.completedCount}',
                                    label: 'Tests Done'.tr)),
                            const SizedBox(width: 8),
                            Expanded(
                                child: _StatBox(value: '${profile.streak}', label: 'Streak Days'.tr)),
                            const SizedBox(width: 8),
                            Expanded(
                                child: _StatBox(
                                    value: '${profile.testStats.bestScore}%', label: 'Best Score'.tr)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionLabel('ACCOUNT'.tr),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: Column(
                    children: [
                      _MenuTile(
                          icon: Icons.person_outline,
                          label: 'Personal Information'.tr,
                          onTap: controller.goToEditProfile),
                      _MenuTile(
                        icon: Icons.notifications_none,
                        label: 'Notifications'.tr,
                        trailing:
                        Switch(value: true, activeColor: AppColors.primary, onChanged: (_) {}),
                      ),
                      _MenuTile(
                        icon: Icons.language,
                        label: 'Language'.tr,
                        onTap: () => _showLanguageDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _SectionLabel('SUBSCRIPTION'.tr),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color: AppColors.surface,
                  child:                   _MenuTile(
                    icon: Icons.credit_card,
                    label: 'My Subscription'.tr,
                    trailing: Text(
                      SubscriptionAccessController.to.isPremium.value
                          ? 'Premium'.tr
                          : 'Free'.tr,
                      style: AppTextStyles.caption.copyWith(
                        color: SubscriptionAccessController.to.isPremium.value
                            ? AppColors.success
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () => Get.toNamed(AppRoutes.subscription),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _SectionLabel('SUPPORT'.tr),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color: AppColors.surface,
                  child: Column(
                    children: [
                      _MenuTile(
                        icon: Icons.help_outline,
                        label: 'FAQ'.tr,
                        onTap: () => Get.toNamed(AppRoutes.faq),
                      ),
                      _MenuTile(
                        icon: Icons.privacy_tip_outlined,
                        label: 'Privacy Policy'.tr,
                        onTap: LegalLinks.openPrivacyPolicy,
                      ),
                      _MenuTile(
                        icon: Icons.description_outlined,
                        label: 'Terms of Service'.tr,
                        onTap: LegalLinks.openTerms,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => Material(
                  color: AppColors.errorBg,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: controller.isLoggingOut.value ? null : controller.logout,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout, color: AppColors.error, size: 18),
                          const SizedBox(width: 8),
                          Text('Log Out'.tr,
                              style: AppTextStyles.label.copyWith(color: AppColors.error)),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => Material(
                  color: AppColors.errorBg,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: controller.isDeletingAccount.value
                        ? null
                        : controller.confirmDeleteAccount,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (controller.isDeletingAccount.value)
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.error,
                              ),
                            )
                          else
                            const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Delete Account'.tr,
                            style: AppTextStyles.label.copyWith(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Select Language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('English'.tr),
              onTap: () async {
                await LocaleService.changeLanguage('en');
                Get.back();
              },
            ),
            ListTile(
              title: Text('Swedish'.tr),
              onTap: () async {
                await LocaleService.changeLanguage('sv');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;

  const _StatBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.h3.copyWith(color: AppColors.warning)),
            Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.white70)),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Text(text, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _MenuTile({required this.icon, required this.label, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTextStyles.body)),
            trailing ?? const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}
