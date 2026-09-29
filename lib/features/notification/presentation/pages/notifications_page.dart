import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_motion.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/shimmar_widgets.dart';
import '../../data/models/app_notification_model.dart';
import '../controllers/inbox_controller.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final InboxController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<InboxController>();
    controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Text('Notifications'.tr, style: AppTextStyles.h3),
        centerTitle: true,
        actions: [
          Obx(() {
            final enabled = controller.unreadCount.value > 0 && !controller.isMarkingAll.value;
            return TextButton(
              onPressed: enabled ? controller.markAllRead : null,
              child: Text(
                'Mark all read'.tr,
                style: AppTextStyles.caption.copyWith(
                  color: enabled ? AppColors.primary : AppColors.textHint,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return PageShimmer.notifications();
        }

        if (controller.errorMessage.value != null && controller.items.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.wifi_off,
            message: controller.errorMessage.value!,
            actionText: 'Retry'.tr,
            onAction: controller.load,
          );
        }

        if (controller.items.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.notifications_none,
            message: 'No notifications yet'.tr,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: controller.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = controller.items[index];
              return AppEntrance(
                index: index > 8 ? 8 : index,
                child: _NotificationTile(
                  item: item,
                  onTap: () => controller.openNotification(item),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification item;
  final VoidCallback onTap;

  const _NotificationTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isUpdate = item.type.contains('update');
    final accent = isUpdate ? AppColors.info : AppColors.primary;

    return Material(
      color: item.isRead ? AppColors.white : const Color(0xFFF3F7FC),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.isRead ? AppColors.border : accent.withOpacity(0.28),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withOpacity(item.isRead ? 0.08 : 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isUpdate ? Icons.auto_stories_outlined : Icons.menu_book_outlined,
                  color: accent,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: AppTextStyles.label.copyWith(
                              fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w700,
                              color: item.isRead ? AppColors.textSecondary : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 8, top: 2),
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    if (item.body.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(item.body, style: AppTextStyles.bodySecondary),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      _timeLabel(item.createdAt),
                      style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeLabel(DateTime? time) {
    if (time == null) return '';
    final local = time.toLocal();
    final diff = DateTime.now().difference(local);
    if (diff.inMinutes < 1) return 'Just now'.tr;
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat('d MMM yyyy').format(local);
  }
}
