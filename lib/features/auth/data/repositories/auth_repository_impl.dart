import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return remoteDataSource.register(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  @override
  Future<String> verifyOtp({required String email, required String otp}) {
    return remoteDataSource.verifyOtp(email: email, otp: otp);
  }

  @override
  Future<LoginResponseModel> login({required String email, required String password}) {
    return remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<LoginResponseModel> loginWithGoogle({required String idToken}) {
    return remoteDataSource.loginWithGoogle(idToken: idToken);
  }

  @override
  Future<LoginResponseModel> loginWithApple({
    required String identityToken,
    String? email,
    String? givenName,
    String? familyName,
  }) {
    return remoteDataSource.loginWithApple(
      identityToken: identityToken,
      email: email,
      givenName: givenName,
      familyName: familyName,
    );
  }

  @override
  Future<String> forgotPassword({required String email}) {
    return remoteDataSource.forgotPassword(email: email);
  }

  @override
  Future<Map<String, dynamic>> verifyForgotPasswordOtp({required String email, required String otp}) {
    return remoteDataSource.verifyForgotPasswordOtp(email: email, otp: otp);
  }

  @override
  Future<String> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  }) {
    return remoteDataSource.resetPassword(
      resetToken: resetToken,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }
}
