import 'package:get/get.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/error/exceptions.dart';
import '../../data/models/app_notification_model.dart';
import '../../domain/repositories/notification_repository.dart';

class InboxController extends GetxController {
  InboxController({required NotificationRepository repository}) : _repository = repository;

  final NotificationRepository _repository;

  final RxList<AppNotification> items = <AppNotification>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isMarkingAll = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    refreshUnread();
  }

  Future<void> refreshUnread() async {
    try {
      unreadCount.value = await _repository.fetchUnreadCount();
    } catch (_) {}
  }

  Future<void> load() async {
    isLoading.value = items.isEmpty;
    errorMessage.value = null;
    try {
      final inbox = await _repository.fetchNotifications();
      items.assignAll(inbox.notifications);
      unreadCount.value = inbox.notifications.where((item) => !item.isRead).length;
    } on ApiException catch (e) {
      if (items.isEmpty) errorMessage.value = e.message;
    } catch (_) {
      if (items.isEmpty) {
        errorMessage.value = 'Something went wrong. Please try again.'.tr;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openNotification(AppNotification item) async {
    if (!item.isRead) {
      final index = items.indexWhere((entry) => entry.id == item.id);
      if (index != -1) {
        items[index] = item.copyWith(isRead: true);
        items.refresh();
        if (unreadCount.value > 0) unreadCount.value--;
      }
      try {
        await _repository.markRead(item.id);
      } catch (_) {
        if (index != -1) {
          items[index] = item;
          items.refresh();
          unreadCount.value++;
        }
      }
    }

    final chapterId = item.chapterId;
    if (chapterId != null && chapterId.isNotEmpty) {
      await Get.toNamed(AppRoutes.chapterDetail, arguments: {'chapterId': chapterId});
    }
  }

  Future<void> markAllRead() async {
    if (unreadCount.value == 0 || isMarkingAll.value) return;
    final previous = items.toList();
    final previousCount = unreadCount.value;
    isMarkingAll.value = true;
    items.assignAll(items.map((item) => item.copyWith(isRead: true)));
    unreadCount.value = 0;
    try {
      await _repository.markAllRead();
    } catch (_) {
      items.assignAll(previous);
      unreadCount.value = previousCount;
    } finally {
      isMarkingAll.value = false;
    }
  }
}
