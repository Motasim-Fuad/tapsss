import 'package:get/get.dart';
import '../controllers/subscription_controller.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubscriptionController());
  }
}
