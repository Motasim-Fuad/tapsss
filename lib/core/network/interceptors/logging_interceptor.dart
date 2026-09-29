import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('➡️ ${options.method} ${options.baseUrl}${options.path}');
      if (options.data != null) {
        print('BODY: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('✅ ${response.requestOptions.method} ${response.requestOptions.path} [${response.statusCode}]');
      print('RESPONSE: ${response.data}');
    }
    _breadcrumb(
      response.requestOptions,
      statusCode: response.statusCode,
      level: SentryLevel.info,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('❌ ${err.requestOptions.method} ${err.requestOptions.path} [${err.response?.statusCode}]');
      print('ERROR: ${err.response?.data ?? err.message}');
    }
    _reportApiFailure(err);
    handler.next(err);
  }

  void _breadcrumb(
    RequestOptions options, {
    int? statusCode,
    required SentryLevel level,
  }) {
    try {
      Sentry.addBreadcrumb(
        Breadcrumb(
          category: 'http',
          type: 'http',
          level: level,
          message: '${options.method} ${options.path}',
          data: {
            'method': options.method,
            'path': options.path,
            if (statusCode != null) 'status_code': statusCode,
          },
        ),
      );
    } catch (_) {}
  }

  void _reportApiFailure(DioException err) {
    final status = err.response?.statusCode;
    _breadcrumb(err.requestOptions, statusCode: status, level: SentryLevel.error);

    final isServerOrNetwork = status == null || status >= 500;
    if (!isServerOrNetwork) return;

    final summary =
        '${err.requestOptions.method} ${err.requestOptions.path} [${status ?? err.type.name}]';
    try {
      FirebaseCrashlytics.instance.recordError(
        err,
        err.stackTrace,
        reason: summary,
        fatal: false,
      );
    } catch (_) {}
    try {
      Sentry.captureException(
        err,
        stackTrace: err.stackTrace,
        withScope: (scope) {
          scope.level = SentryLevel.error;
          scope.setTag('api_path', err.requestOptions.path);
        },
      );
    } catch (_) {}
  }
}
