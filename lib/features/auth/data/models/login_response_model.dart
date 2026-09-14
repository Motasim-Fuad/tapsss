import '../../../../core/utils/json_parsers.dart';
import 'user_model.dart';

class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      user: UserModel.fromJson(asJsonMap(json['userData'] ?? json['user'])),
    );
  }
}
