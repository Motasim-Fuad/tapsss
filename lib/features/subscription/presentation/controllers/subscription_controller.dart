import 'package:get/get.dart';

class SubscriptionPlan {
  final String id;
  final String label;
  final String price;
  final String? subLabel;
  final String? badge;

  SubscriptionPlan({
    required this.id,
    required this.label,
    required this.price,
    this.subLabel,
    this.badge,
  });
}

class SubscriptionController extends GetxController {
  final RxString selectedPlanId = 'yearly'.obs;

  final List<SubscriptionPlan> plans = [
    SubscriptionPlan(id: '3months', label: '3 Months', price: '49 SEK', subLabel: '/48 SEK/month'),
    SubscriptionPlan(id: '6months', label: '6 Months', price: '149 SEK', badge: 'Most Popular'),
    SubscriptionPlan(id: 'yearly', label: 'Yearly', price: '999 SEK', subLabel: '/83 SEK/month', badge: 'Save 44%'),
  ];

  void selectPlan(String id) {
    selectedPlanId.value = id;
  }

  void unlockPremium() {
    // Frontend only for now — payment integration will be wired up separately.
  }
}
