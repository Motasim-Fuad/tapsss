import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../core/services/revenuecat_service.dart';
import 'subscription_access_controller.dart';

class SubscriptionPlan {
  final String id;
  final String label;
  final String productId;
  final Package package;
  final String price;
  final String? subLabel;
  final String? badge;

  SubscriptionPlan({
    required this.id,
    required this.label,
    required this.productId,
    required this.package,
    required this.price,
    this.subLabel,
    this.badge,
  });
}

class SubscriptionController extends GetxController {
  final RxString selectedPlanId = ''.obs;

  final RxBool isLoading = true.obs;
  final RxBool isPurchasing = false.obs;

  RxBool get isPremium => SubscriptionAccessController.to.isPremium;

  final RxList<SubscriptionPlan> plans = <SubscriptionPlan>[].obs;


  Offering? currentOffering;

  // iOS product IDs
  static const Map<String, String> _iosProductLabels = {
    '3_months_premium_study_materials': '3 Months',
    '6_months_premium_study_materials': '6 Months',
    'yearly_premium_study_materials': 'Yearly',
  };

  // Android product IDs
  static const Map<String, String> _androidProductLabels = {
    'tapass_premium:3-months-premium-study-materials': '3 Months',
    'tapass_premium:6-months-premium-study-materials': '6 Months',
    'tapass_premium:yearly-premium-study-materials': 'Yearly',
  };

  static Map<String, String> get _productLabels =>
      Platform.isAndroid ? _androidProductLabels : _iosProductLabels;

  static String get _yearlyProductId => Platform.isAndroid
      ? 'tapass_premium:yearly-premium-study-materials'
      : 'yearly_premium_study_materials';

  static String get _sixMonthProductId => Platform.isAndroid
      ? 'tapass_premium:6-months-premium-study-materials'
      : '6_months_premium_study_materials';

  static const List<String> _iosProductOrder = [
    '3_months_premium_study_materials',
    '6_months_premium_study_materials',
    'yearly_premium_study_materials',
  ];

  static const List<String> _androidProductOrder = [
    'tapass_premium:3-months-premium-study-materials',
    'tapass_premium:6-months-premium-study-materials',
    'tapass_premium:yearly-premium-study-materials',
  ];

  static List<String> get _productOrder =>
      Platform.isAndroid ? _androidProductOrder : _iosProductOrder;

  @override
  void onInit() {
    super.onInit();
    loadSubscription();
  }

  Future<void> loadSubscription() async {
    isLoading.value = true;

    try {
      // This already returns the CURRENT Offering.
      final Offering? offering =
      await RevenueCatService.getCurrentOffering();

      currentOffering = offering;

      final loadedPlans = <SubscriptionPlan>[];

      if (offering != null) {
        // No .current here because `offering` is already an Offering.
        for (final package in offering.availablePackages) {
          final productId = package.storeProduct.identifier;
          final label = _productLabels[productId];

          if (label == null) {
            continue;
          }

          loadedPlans.add(
            SubscriptionPlan(
              id: productId,
              label: label,
              productId: productId,
              package: package,
              price: package.storeProduct.priceString,
              subLabel: _subLabel(
                productId,
                package.storeProduct.priceString,
              ),
              badge: productId == _sixMonthProductId
                  ? 'Most Popular'
                  : productId == _yearlyProductId
                  ? 'Save 44%'
                  : null,
            ),
          );
        }
      }

      loadedPlans.sort(
        (a, b) => _productOrder
            .indexOf(a.productId)
            .compareTo(_productOrder.indexOf(b.productId)),
      );

      plans.assignAll(loadedPlans);

      if (plans.isNotEmpty &&
          !plans.any((plan) => plan.id == selectedPlanId.value)) {
        if (plans.any((plan) => plan.productId == _yearlyProductId)) {
          selectedPlanId.value = _yearlyProductId;
        } else {
          selectedPlanId.value = plans.first.id;
        }
      }

      await SubscriptionAccessController.to.syncFromStore();
    } catch (e) {
      debugPrint(
        '[RevenueCat] Failed to load subscription: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? _subLabel(String productId, String price) {
    return null;
  }

  void selectPlan(String id) {
    selectedPlanId.value = id;
  }

  SubscriptionPlan? get selectedPlan {
    for (final plan in plans) {
      if (plan.id == selectedPlanId.value) return plan;
    }
    return plans.isNotEmpty ? plans.first : null;
  }

  Future<void> unlockPremium() async {
    final plan = selectedPlan;

    if (plan == null) {
      Get.snackbar(
        'Subscription',
        'No subscription plan is currently available.',
      );
      return;
    }

    if (isPurchasing.value) return;

    isPurchasing.value = true;

    try {
      await RevenueCatService.purchase(plan.package);
      await SubscriptionAccessController.to.syncFromStore();

      if (isPremium.value) {
        Get.snackbar(
          'Payment Successful',
          '${plan.price} ${plan.label} subscription is now active.',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back();
      }
    } catch (e) {
      final message = e.toString();

      // RevenueCat returns a platform exception for cancellation too.
      if (message.toLowerCase().contains('cancel')) {
        return;
      }

      debugPrint('[RevenueCat] Purchase failed: $e');

      Get.snackbar(
        'Payment Failed',
        'We could not complete the purchase. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isPurchasing.value = false;
    }
  }

  Future<void> restorePurchases() async {
    try {
      await RevenueCatService.restorePurchases();
      await SubscriptionAccessController.to.syncFromStore();

      Get.snackbar(
        'Restore Purchases',
        isPremium.value
            ? 'Your premium subscription has been restored.'
            : 'No active premium subscription was found.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint('[RevenueCat] Restore failed: $e');
      Get.snackbar(
        'Restore Failed',
        'Could not restore purchases. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
