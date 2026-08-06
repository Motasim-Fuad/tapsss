import 'package:arashmati_app/core/services/notification_services.dart';
import 'package:flutter/foundation.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/constants/storage_keys.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _dataSource;
  final StorageService _storageService;

  NotificationRepositoryImpl({
    required NotificationRemoteDataSource dataSource,
    required StorageService storageService,
  })  : _dataSource = dataSource,
        _storageService = storageService;

  @override
  Future<bool> registerToken() async {
    try {
      final existingId = await _storageService.getNotificationTokenId();
      if (existingId != null && existingId.isNotEmpty) {
        if (kDebugMode) print('Token already registered');
        return true;
      }

      // Memory থেকে সরাসরি নাও
      final token = NotificationService.to.fcmToken.value;
      if (token == null || token.isEmpty) {
        if (kDebugMode) print('No token available');
        return false;
      }

      final tokenId = await _dataSource.registerNotificationToken(token);
      if (tokenId != null && tokenId.isNotEmpty) {
        await _storageService.saveNotificationTokenId(tokenId);
        if (kDebugMode) print('Token registered, ID: $tokenId');
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) print('registerToken error: $e');
      return false;
    }
  }

  @override
  Future<void> clearTokenData() async {
    try {
      await _storageService.deleteNotificationTokenId();
      if (kDebugMode) print('Token ID cleared');
    } catch (e) {
      if (kDebugMode) print('clearTokenData error: $e');
    }
  }
}