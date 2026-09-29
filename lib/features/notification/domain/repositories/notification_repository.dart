import '../../data/models/app_notification_model.dart';

abstract class NotificationRepository {
  Future<bool> registerToken();
  Future<void> clearTokenData();
  Future<NotificationInbox> fetchNotifications();
  Future<int> fetchUnreadCount();
  Future<void> markRead(String id);
  Future<void> markAllRead();
}