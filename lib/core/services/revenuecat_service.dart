import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';


class RevenueCatService {
  RevenueCatService._();

  static const String entitlementId = 'Tapass Pro';

  static String get _iosApiKey =>
      dotenv.env['REVENUECAT_IOS_API_KEY'] ?? '';

  static String get _androidApiKey =>
      dotenv.env['REVENUECAT_ANDROID_API_KEY'] ?? '';

  static bool _configured = false;
  static bool _listenerAttached = false;
  static final List<void Function(CustomerInfo)> _customerInfoListeners = [];

  static String get _apiKey {
    if (Platform.isIOS) return _iosApiKey;
    if (Platform.isAndroid) return _androidApiKey;
    return '';
  }

  static Future<void> configure({String? appUserId}) async {
    if (!Platform.isIOS && !Platform.isAndroid) {
      debugPrint('[RevenueCat] Unsupported platform.');
      return;
    }

    if (_apiKey.isEmpty) {
      debugPrint(
        '[RevenueCat] Missing public SDK key. '
        'Use --dart-define=REVENUECAT_IOS_API_KEY=... and/or '
        '--dart-define=REVENUECAT_ANDROID_API_KEY=...',
      );
      return;
    }

    if (!_configured) {
      final configuration = PurchasesConfiguration(_apiKey);

      if (appUserId != null && appUserId.isNotEmpty) {
        configuration.appUserID = appUserId;
      }

      await Purchases.configure(configuration);
      await Purchases.setLogLevel(LogLevel.info);
      _configured = true;
      _attachCustomerInfoListener();

      debugPrint('[RevenueCat] Configured successfully.');
    } else if (appUserId != null && appUserId.isNotEmpty) {
      final currentId = await Purchases.appUserID;
      if (currentId != appUserId) {
        await Purchases.logIn(appUserId);
      }
    }
  }

  static Future<void> logIn(String appUserId) async {
    if (appUserId.isEmpty) return;
    await configure(appUserId: appUserId);
  }

  static Future<void> logOut() async {
    if (!_configured) return;
    await Purchases.logOut();
  }

  static Future<Offering?> getCurrentOffering() async {
    await configure();
    if (!_configured) return null;

    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current;
    } catch (e) {
      debugPrint('[RevenueCat] getOfferings failed: $e');
      return null;
    }
  }

  static Future<CustomerInfo?> getCustomerInfo() async {
    await configure();
    if (!_configured) return null;
    return Purchases.getCustomerInfo();
  }

  static void addCustomerInfoUpdateListener(
    void Function(CustomerInfo) listener,
  ) {
    _customerInfoListeners.add(listener);
    if (_configured) {
      _attachCustomerInfoListener();
    }
  }

  static void _attachCustomerInfoListener() {
    if (_listenerAttached || !_configured) return;
    Purchases.addCustomerInfoUpdateListener((info) {
      for (final listener in List.of(_customerInfoListeners)) {
        listener(info);
      }
    });
    _listenerAttached = true;
  }

  static bool isPremium(CustomerInfo info) {
    final named = info.entitlements.all[entitlementId];
    if (named?.isActive == true) return true;
    return info.entitlements.active.containsKey(entitlementId);
  }

  static DateTime? premiumExpiration(CustomerInfo info) {
    final entitlement = info.entitlements.all[entitlementId];
    if (entitlement == null || !entitlement.isActive) return null;
    final raw = entitlement.expirationDate;
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  static Future<PurchaseResult> purchase(Package package) async {
    await configure();

    final result = await Purchases.purchasePackage(package);
    return result;
  }

  static Future<CustomerInfo> restorePurchases() async {
    await configure();
    return Purchases.restorePurchases();
  }
}
