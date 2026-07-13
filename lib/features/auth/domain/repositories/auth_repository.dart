import '../../data/models/login_response_model.dart';

abstract class AuthRepository {
  Future<String> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<String> verifyOtp({required String email, required String otp});

  Future<LoginResponseModel> login({required String email, required String password});

  Future<String> forgotPassword({required String email});

  Future<Map<String, dynamic>> verifyForgotPasswordOtp({required String email, required String otp});

  Future<String> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  });

  Future<void> logout();
}
