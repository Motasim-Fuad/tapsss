import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  ApiEndpoints._();

  /// iPhone cannot use localhost — that is the phone itself.
  /// Use the Mac LAN IP while the backend runs on this machine.
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://10.10.28.177:8001';

  static const String register = '/api/auth/register';
  static const String verifyOtp = '/api/auth/verify-otp';
  static const String login = '/api/auth/login/';
  static const String googleLogin = '/api/auth/google';
  static const String appleLogin = '/api/auth/apple';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String forgotPasswordOtp = '/api/auth/forgot-password-otp';
  static const String resetPassword = '/api/auth/reset-password';
  static const String logout = '/api/auth/logout';
  static const String refreshToken = '/api/auth/refresh-token';
  static const String changeLanguage = '/api/auth/language';

  static const String registerNotificationToken = '/api/notification/register-fcm-token';


  static const String dashboard = '/api/dashboard';

  static const String studyMaterials = '/api/user-study/materials';
  static String chapterDetails(String chapterId) => '/api/user-study/chapter/$chapterId';
  static const String markChapterComplete = '/api/user-study/chapter/complete';

  static const String tests = '/api/tests';
  static String testByNumber(int testNumber) => '/api/tests/$testNumber';
  static String startTest(int testNumber) => '/api/tests/$testNumber/start';
  static String submitTest(int testNumber) => '/api/tests/$testNumber/submit';

  static const String progressOverview = '/api/progress/overview';
  static const String testHistory = '/api/progress/test-history';
  static const String scoreHistory = '/api/progress/score-history';

  static const String profile = '/api/profile';
}
