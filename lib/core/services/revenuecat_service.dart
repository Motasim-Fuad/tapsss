import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';


class RevenueCatService {
  RevenueCatService._();

  static const String entitlementId = 'Tapass Pro';

  static const String _iosApiKey =
      String.fromEnvironment('REVENUECAT_IOS_API_KEY');

  static const String _androidApiKey =
      String.fromEnvironment('REVENUECAT_ANDROID_API_KEY');

  static bool _configured = false;

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
      await Purchases.setLogLevel(LogLevel.debug);
      _configured = true;

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

    debugPrint('');
    debugPrint('════════════ REVENUECAT OFFERINGS DEBUG ════════════');
    debugPrint('[RevenueCat] configured: $_configured');
    debugPrint('[RevenueCat] platform: ${Platform.operatingSystem}');
    debugPrint('[RevenueCat] appUserId: ${await Purchases.appUserID}');

    if (!_configured) {
      debugPrint('[RevenueCat] ❌ SDK is NOT configured.');
      debugPrint('═══════════════════════════════════════════════════');
      return null;
    }

    try {
      final Offerings offerings = await Purchases.getOfferings();

      // 1. All offerings
      debugPrint(
        '[RevenueCat] ALL OFFERINGS: '
            '${offerings.all.keys.toList()}',
      );

      // 2. Current offering
      final Offering? current = offerings.current;

      if (current == null) {
        debugPrint('[RevenueCat] ❌ CURRENT OFFERING: NULL');
        debugPrint(
          '[RevenueCat] There is no current/default offering.',
        );
        debugPrint(
          '[RevenueCat] This is most likely a RevenueCat Offering configuration issue.',
        );
        debugPrint(
          '[RevenueCat] Check Product Catalog → Offerings.',
        );
        debugPrint('═══════════════════════════════════════════════════');
        return null;
      }

      debugPrint(
        '[RevenueCat] ✅ CURRENT OFFERING: ${current.identifier}',
      );

      // 3. Available packages
      final packages = current.availablePackages;

      debugPrint(
        '[RevenueCat] PACKAGE COUNT: ${packages.length}',
      );

      if (packages.isEmpty) {
        debugPrint('[RevenueCat] ❌ NO PACKAGES FOUND');
        debugPrint(
          '[RevenueCat] Current offering exists, '
              'but it has no available packages.',
        );
        debugPrint(
          '[RevenueCat] Check whether products are attached '
              'to packages inside this Offering.',
        );
      }

      // 4. Print every package/product
      for (final package in packages) {
        final product = package.storeProduct;

        debugPrint('');
        debugPrint('──────── PACKAGE ────────');
        debugPrint(
          '[RevenueCat] package identifier: ${package.identifier}',
        );
        debugPrint(
          '[RevenueCat] package type: ${package.packageType}',
        );
        debugPrint(
          '[RevenueCat] product identifier: ${product.identifier}',
        );
        debugPrint(
          '[RevenueCat] product title: ${product.title}',
        );
        debugPrint(
          '[RevenueCat] product description: ${product.description}',
        );
        debugPrint(
          '[RevenueCat] price: ${product.priceString}',
        );
        debugPrint(
          '[RevenueCat] currency: ${product.currencyCode}',
        );
        debugPrint(
          '[RevenueCat] raw price: ${product.price}',
        );
        debugPrint('─────────────────────────');
      }

      debugPrint('');
      debugPrint('═══════════════════════════════════════════════════');

      return current;
    } catch (e, stackTrace) {
      debugPrint('');
      debugPrint('════════════ REVENUECAT OFFERINGS ERROR ═══════════');
      debugPrint('[RevenueCat] ❌ ERROR: $e');
      debugPrint('[RevenueCat] STACK TRACE: $stackTrace');
      debugPrint('═══════════════════════════════════════════════════');

      return null;
    }
  }

  static Future<CustomerInfo?> getCustomerInfo() async {
    await configure();
    if (!_configured) return null;
    return Purchases.getCustomerInfo();
  }

  static bool isPremium(CustomerInfo info) {
    return info.entitlements.all[entitlementId]?.isActive ?? false;
  }

  static Future<PurchaseResult> purchase(Package package) async {
    await configure();

    final result = await Purchases.purchasePackage(package);

    final customerInfo = result.customerInfo;
    final product = package.storeProduct;

    if (isPremium(customerInfo)) {
      debugPrint('');
      debugPrint('════════════ REVENUECAT PAYMENT SUCCESS ════════════');
      debugPrint('appUserId: ${await Purchases.appUserID}');
      debugPrint('productId: ${product.identifier}');
      debugPrint('price: ${product.priceString}');
      debugPrint('currency: ${product.currencyCode}');
      debugPrint('entitlement: $entitlementId');
      debugPrint(
        'activeEntitlements: '
        '${customerInfo.entitlements.active.keys.toList()}',
      );
      debugPrint(
        'activeSubscriptions: '
        '${customerInfo.activeSubscriptions}',
      );
      debugPrint('premiumActive: true');
      debugPrint('═══════════════════════════════════════════════════');
      debugPrint('');
    }

    return result;
  }

  static Future<CustomerInfo> restorePurchases() async {
    await configure();
    return Purchases.restorePurchases();
  }
}
