import 'package:dio/dio.dart';
import 'package:firebase_performance/firebase_performance.dart';

/// Records Dio calls in Firebase Performance. Failures here never block the API.
class PerformanceInterceptor extends Interceptor {
  static const _extraKey = 'firebase_http_metric';

  HttpMethod? _method(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return HttpMethod.Get;
      case 'POST':
        return HttpMethod.Post;
      case 'PUT':
        return HttpMethod.Put;
      case 'PATCH':
        return HttpMethod.Patch;
      case 'DELETE':
        return HttpMethod.Delete;
      case 'HEAD':
        return HttpMethod.Head;
      case 'OPTIONS':
        return HttpMethod.Options;
      default:
        return null;
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final method = _method(options.method);
      if (method != null) {
        final metric = FirebasePerformance.instance.newHttpMetric(
          options.uri.toString(),
          method,
        );
        await metric.start();
        options.extra[_extraKey] = metric;
      }
    } catch (_) {}
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    await _stop(response.requestOptions, response.statusCode);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    await _stop(err.requestOptions, err.response?.statusCode);
    handler.next(err);
  }

  Future<void> _stop(RequestOptions options, int? statusCode) async {
    final metric = options.extra.remove(_extraKey);
    if (metric is! HttpMetric) return;
    try {
      if (statusCode != null) {
        metric.httpResponseCode = statusCode;
      }
      await metric.stop();
    } catch (_) {}
  }
}
