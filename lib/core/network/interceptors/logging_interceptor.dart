import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('➡️ ${options.method} ${options.baseUrl}${options.path}');
    if (options.data != null) {
      print('BODY: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ ${response.requestOptions.method} ${response.requestOptions.path} [${response.statusCode}]');
    print('RESPONSE: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ${err.requestOptions.method} ${err.requestOptions.path} [${err.response?.statusCode}]');
    print('ERROR: ${err.response?.data ?? err.message}');
    handler.next(err);
  }
}
