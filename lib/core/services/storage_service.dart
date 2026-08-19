import 'package:arashmati_app/core/constants/storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  Future<void> write(String key, String value) => _storage.write(key: key, value: value);

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> deleteAll() => _storage.deleteAll();


  // ✅ Notification Token ID (backend থেকে আসা id)
  Future<void> saveNotificationTokenId(String id) =>
      write(StorageKeys.notificationTokenId, id);

  Future<String?> getNotificationTokenId() =>
      read(StorageKeys.notificationTokenId);

  Future<void> deleteNotificationTokenId() =>
      delete(StorageKeys.notificationTokenId);
}