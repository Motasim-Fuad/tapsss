import 'dart:io';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/app_notification_model.dart';

class NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSource(this.apiClient);

  static String getDeviceType() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'android';
  }

  Future<String?> registerNotificationToken(String token) async {
    final response = await apiClient.post(
      ApiEndpoints.registerNotificationToken,
      data: {
        'deviceToken': token,
        'deviceType': getDeviceType(),
      },
    );

    final success = response.data['success'] == true;
    if (success) return 'registered';
    return null;
  }

  Future<NotificationInbox> fetchNotifications() async {
    final response = await apiClient.get(ApiEndpoints.notifications);
    return NotificationInbox.fromJson(response.data);
  }

  Future<int> fetchUnreadCount() async {
    final response = await apiClient.get(ApiEndpoints.notificationUnreadCount);
    final data = response.data;
    if (data is Map && data['unreadCount'] != null) {
      return int.tryParse(data['unreadCount'].toString()) ?? 0;
    }
    return 0;
  }

  Future<void> markRead(String id) async {
    await apiClient.patch(
      ApiEndpoints.notificationRead(id),
      data: {'isRead': true},
    );
  }

  Future<void> markAllRead() async {
    await apiClient.patch(ApiEndpoints.notificationReadAll);
  }
}