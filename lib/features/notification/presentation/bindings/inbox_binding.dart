import 'package:get/get.dart';

import '../../domain/repositories/notification_repository.dart';
import '../controllers/inbox_controller.dart';

class InboxBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<InboxController>()) {
      Get.put(InboxController(repository: Get.find<NotificationRepository>()));
    }
  }
}
