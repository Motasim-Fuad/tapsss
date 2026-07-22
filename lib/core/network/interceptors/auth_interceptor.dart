import 'package:dio/dio.dart';
import '../../constants/api_endpoints.dart';
import '../../constants/storage_keys.dart';
import '../../services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  final StorageService storageService;
  final Dio dio;

  bool _isRefreshing = false;

  AuthInterceptor({required this.storageService, required this.dio});

  static const List<String> _publicPaths = [
    ApiEndpoints.register,
    ApiEndpoints.verifyOtp,
    ApiEndpoints.login,
    ApiEndpoints.forgotPassword,
    ApiEndpoints.forgotPasswordOtp,
    ApiEndpoints.resetPassword,
    ApiEndpoints.refreshToken,
  ];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!_publicPaths.contains(options.path)) {
      final token = await storageService.read(StorageKeys.accessToken);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isPublicPath = _publicPaths.contains(err.requestOptions.path);

    if (isUnauthorized && !isPublicPath && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshToken = await storageService.read(StorageKeys.refreshToken);
        if (refreshToken == null || refreshToken.isEmpty) {
          _isRefreshing = false;
          return handler.next(err);
        }

        final response = await dio.post(
          ApiEndpoints.refreshToken,
          data: {'refresh': refreshToken},
        );

        final newAccessToken = response.data['data']?['access'];
        final newRefreshToken = response.data['data']?['refresh'];

        if (newAccessToken != null) {
          await storageService.write(StorageKeys.accessToken, newAccessToken);
          if (newRefreshToken != null) {
            await storageService.write(StorageKeys.refreshToken, newRefreshToken);
          }

          final retryOptions = err.requestOptions;
          retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          _isRefreshing = false;
          final retryResponse = await dio.fetch(retryOptions);
          return handler.resolve(retryResponse);
        }
      } catch (_) {
        _isRefreshing = false;
        return handler.next(err);
      }
    }

    _isRefreshing = false;
    handler.next(err);
  }
}
