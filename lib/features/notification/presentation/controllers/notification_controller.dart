import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();

  final NotificationRepository _repo;

  NotificationController({required NotificationRepository repo})
      : _repo = repo;

  final RxBool isRegistered = false.obs;

  Future<void> register() async {
    isRegistered.value = await _repo.registerToken();
    if (kDebugMode) print('Token registration: ${isRegistered.value}');
  }

  Future<void> clear() async {
    await _repo.clearTokenData();
    isRegistered.value = false;
    if (kDebugMode) print('Token data cleared');
  }
}