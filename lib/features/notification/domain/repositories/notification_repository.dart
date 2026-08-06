abstract class NotificationRepository {
  Future<bool> registerToken();
  Future<void> clearTokenData();
}