import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/services/revenuecat_service.dart';

class SubscriptionAccessController extends GetxController
    with WidgetsBindingObserver {
  static const int freeChapterCount = 1;
  static const int freeTestCount = 1;

  final RxBool isPremium = false.obs;
  final Rxn<DateTime> expirationDate = Rxn<DateTime>();
  final RxBool isSyncing = false.obs;

  static SubscriptionAccessController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    RevenueCatService.addCustomerInfoUpdateListener(_applyCustomerInfo);
    syncFromStore();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      syncFromStore();
    }
  }

  Future<void> identifyUser(String userId) async {
    if (userId.isEmpty) return;
    try {
      await RevenueCatService.logIn(userId);
    } catch (e) {
      debugPrint('[RevenueCat] identify failed: $e');
    }
    await syncFromStore();
  }

  Future<void> clearUser() async {
    try {
      await RevenueCatService.logOut();
    } catch (e) {
      debugPrint('[RevenueCat] logout failed: $e');
    }
    isPremium.value = false;
    expirationDate.value = null;
  }

  Future<void> syncFromStore() async {
    isSyncing.value = true;
    try {
      final info = await RevenueCatService.getCustomerInfo();
      if (info != null) {
        _applyCustomerInfo(info);
      } else {
        isPremium.value = false;
        expirationDate.value = null;
      }
    } catch (e) {
      debugPrint('[RevenueCat] sync failed: $e');
    } finally {
      isSyncing.value = false;
    }
  }

  void _applyCustomerInfo(CustomerInfo info) {
    final wasPremium = isPremium.value;
    isPremium.value = RevenueCatService.isPremium(info);
    expirationDate.value = RevenueCatService.premiumExpiration(info);

    if (wasPremium && !isPremium.value) {
      debugPrint('[RevenueCat] Entitlement expired or cancelled — locking features.');
    }
  }

  bool canAccessChapter(int chapterNumber) {
    if (isPremium.value) return true;
    if (chapterNumber <= 0) return false;
    return chapterNumber <= freeChapterCount;
  }

  bool canAccessTest(int testNumber) {
    if (isPremium.value) return true;
    if (testNumber <= 0) return false;
    return testNumber <= freeTestCount;
  }

  bool requireChapterAccess(int chapterNumber) {
    if (canAccessChapter(chapterNumber)) return true;
    openPaywall();
    return false;
  }

  bool requireTestAccess(int testNumber) {
    if (canAccessTest(testNumber)) return true;
    openPaywall();
    return false;
  }

  void openPaywall() {
    if (Get.currentRoute == AppRoutes.subscription) return;
    Get.toNamed(AppRoutes.subscription);
  }
}
