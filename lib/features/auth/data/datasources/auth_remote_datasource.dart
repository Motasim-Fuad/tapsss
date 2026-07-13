import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_response_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<String> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await apiClient.post(ApiEndpoints.register, data: {
      'name': name,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    });
    return response.data['msg']?.toString() ?? 'OTP sent to your email';
  }

  Future<String> verifyOtp({required String email, required String otp}) async {
    final response = await apiClient.post(ApiEndpoints.verifyOtp, data: {
      'email': email,
      'otp': otp,
    });
    return response.data['msg']?.toString() ?? 'Verified successfully';
  }

  Future<LoginResponseModel> login({required String email, required String password}) async {
    final response = await apiClient.post(ApiEndpoints.login, data: {
      'email': email,
      'password': password,
    });
    return LoginResponseModel.fromJson(response.data);
  }

  Future<String> forgotPassword({required String email}) async {
    final response = await apiClient.post(ApiEndpoints.forgotPassword, data: {
      'email': email,
    });
    return response.data['msg']?.toString() ?? 'OTP sent to your email';
  }

  /// Returns the resetToken (if the backend issues one) alongside the message.
  Future<Map<String, dynamic>> verifyForgotPasswordOtp({
    required String email,
    required String otp,
  }) async {
    final response = await apiClient.post(ApiEndpoints.forgotPasswordOtp, data: {
      'email': email,
      'otp': otp,
    });
    return {
      'msg': response.data['msg']?.toString() ?? 'OTP verified',
      'resetToken': response.data['resetToken']?.toString(),
    };
  }

  Future<String> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final response = await apiClient.post(ApiEndpoints.resetPassword, data: {
      'resetToken': resetToken,
      'newPassword': newPassword,
      'confirmNewPassword': confirmNewPassword,
    });
    return response.data['msg']?.toString() ?? 'Password changed successfully';
  }

  Future<void> logout() async {
    await apiClient.post(ApiEndpoints.logout);
  }
}
