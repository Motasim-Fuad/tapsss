import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Crash, error, performance, analytics, and remote-config setup.
/// None of this changes navigation or API results.
class Observability {
  Observability._();

  static bool sentryEnabled = false;

  static Future<void> start() async {
    final dsn = dotenv.env['SENTRY_DSN']?.trim() ?? '';
    sentryEnabled = dsn.isNotEmpty;

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);

    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 8),
        minimumFetchInterval: const Duration(hours: 12),
      ),
    );
    unawaited(
      remoteConfig.fetchAndActivate().catchError((_) => false),
    );
  }

  static void configureSentry(SentryFlutterOptions options) {
    options.dsn = dotenv.env['SENTRY_DSN']?.trim();
    options.environment = kReleaseMode ? 'production' : 'development';
    options.tracesSampleRate = 0.2;
    options.sendDefaultPii = false;
  }

  static void bindErrorHandlers() {
    final previousFlutter = FlutterError.onError;
    FlutterError.onError = (details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      if (previousFlutter != null) {
        previousFlutter(details);
      } else {
        FlutterError.presentError(details);
      }
    };

    final previousPlatform = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      final handled = previousPlatform?.call(error, stack) ?? false;
      return handled || true;
    };
  }

  static List<NavigatorObserver>? _observers;

  static List<NavigatorObserver> get navigatorObservers {
    return _observers ??= [
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      if (sentryEnabled) SentryNavigatorObserver(),
    ];
  }

  static Future<void> setUser(String id) async {
    if (id.isEmpty) return;
    try {
      await FirebaseAnalytics.instance.setUserId(id: id);
      await FirebaseCrashlytics.instance.setUserIdentifier(id);
      if (sentryEnabled) {
        await Sentry.configureScope(
          (scope) => scope.setUser(SentryUser(id: id)),
        );
      }
    } catch (_) {}
  }

  static Future<void> clearUser() async {
    try {
      await FirebaseAnalytics.instance.setUserId(id: null);
      await FirebaseCrashlytics.instance.setUserIdentifier('');
      if (sentryEnabled) {
        await Sentry.configureScope((scope) => scope.setUser(null));
      }
    } catch (_) {}
  }
}
