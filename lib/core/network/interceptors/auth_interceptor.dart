import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../../constants/api_endpoints.dart';
import '../../constants/storage_keys.dart';
import '../../services/storage_service.dart';
import '../../../features/auth/presentation/controllers/auth_session_controller.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.storageService, required this.dio});

  final StorageService storageService;
  final Dio dio;

  static const _retryFlag = 'auth_retried';

  Future<String?>? _refreshing;
  bool _handlingInvalidSession = false;

  static const List<String> _publicPaths = [
    ApiEndpoints.register,
    ApiEndpoints.verifyOtp,
    ApiEndpoints.login,
    ApiEndpoints.googleLogin,
    ApiEndpoints.appleLogin,
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
    if (!_shouldRefresh(err)) {
      return handler.next(err);
    }

    try {
      final token = await _refreshAccessToken();
      if (token == null || token.isEmpty) {
        _onRefreshFailed();
        return handler.next(err);
      }

      final request = err.requestOptions;
      request.headers['Authorization'] = 'Bearer $token';
      request.extra[_retryFlag] = true;
      final response = await dio.fetch(request);
      return handler.resolve(response);
    } catch (_) {
      return handler.next(err);
    }
  }

  bool _shouldRefresh(DioException err) {
    if (err.response?.statusCode != 401) return false;
    if (_publicPaths.contains(err.requestOptions.path)) return false;
    if (err.requestOptions.extra[_retryFlag] == true) return false;
    return true;
  }

  Future<String?> _refreshAccessToken() {
    final inFlight = _refreshing;
    if (inFlight != null) return inFlight;
    final future = _doRefresh();
    _refreshing = future;
    return future.whenComplete(() {
      if (identical(_refreshing, future)) {
        _refreshing = null;
      }
    });
  }

  Future<String?> _doRefresh() async {
    final refreshToken = await storageService.read(StorageKeys.refreshToken);
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      final data = response.data;
      final payload = data is Map ? data : null;
      final newAccessToken = payload?['accessToken']?.toString();
      final newRefreshToken = payload?['refreshToken']?.toString();

      if (newAccessToken == null || newAccessToken.isEmpty) return null;

      await storageService.write(StorageKeys.accessToken, newAccessToken);
      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await storageService.write(StorageKeys.refreshToken, newRefreshToken);
      }
      return newAccessToken;
    } catch (_) {
      return null;
    }
  }

  void _onRefreshFailed() {
    if (_handlingInvalidSession) return;
    _handlingInvalidSession = true;
    Future.microtask(() async {
      try {
        if (Get.isRegistered<AuthSessionController>()) {
          await Get.find<AuthSessionController>().onSessionExpired();
        }
      } finally {
        _handlingInvalidSession = false;
      }
    });
  }
}
