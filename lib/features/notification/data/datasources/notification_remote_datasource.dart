import 'dart:io';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

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
}