import 'package:get/get.dart';
import '../../features/auth/presentation/bindings/auth_binding.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/onboarding/presentation/bindings/onboarding_binding.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/bindings/profile_binding.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/splash/presentation/bindings/splash_binding.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/study/presentation/bindings/study_binding.dart';
import '../../features/study/presentation/pages/chapter_detail_page.dart';
import '../../features/subscription/presentation/bindings/subscription_binding.dart';
import '../../features/subscription/presentation/pages/subscription_page.dart';
import '../../features/test/presentation/bindings/test_binding.dart';
import '../../features/test/presentation/pages/exam_page.dart';
import '../../features/test/presentation/pages/review_answers_page.dart';
import '../../features/test/presentation/pages/test_detail_page.dart';
import '../../features/test/presentation/pages/test_result_page.dart';
import '../bindings/main_binding.dart';
import 'app_routes.dart';
import 'main_page.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashPage(), binding: SplashBinding()),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      bindings: [AuthBinding(), LoginBinding()],
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupPage(),
      bindings: [AuthBinding(), SignupBinding()],
    ),
    GetPage(
      name: AppRoutes.verifyOtp,
      page: () => const OtpVerificationPage(),
      bindings: [AuthBinding(), OtpBinding()],
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordPage(),
      bindings: [AuthBinding(), ForgotPasswordBinding()],
    ),
    GetPage(
      name: AppRoutes.verifyForgotOtp,
      page: () => const OtpVerificationPage(),
      bindings: [AuthBinding(), OtpBinding()],
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordPage(),
      bindings: [AuthBinding(), ResetPasswordBinding()],
    ),
    GetPage(name: AppRoutes.main, page: () => const MainPage(), binding: MainBinding()),
    GetPage(
      name: AppRoutes.testDetail,
      page: () => const TestDetailPage(),
      bindings: [TestBinding(), TestDetailBinding()],
    ),
    GetPage(
      name: AppRoutes.exam,
      page: () => const ExamPage(),
      bindings: [TestBinding(), ExamBinding()],
    ),
    GetPage(
      name: AppRoutes.testResult,
      page: () => const TestResultPage(),
      binding: TestResultBinding(),
    ),
    GetPage(
      name: AppRoutes.reviewAnswers,
      page: () => const ReviewAnswersPage(),
      binding: ReviewAnswersBinding(),
    ),
    GetPage(
      name: AppRoutes.chapterDetail,
      page: () => const ChapterDetailPage(),
      bindings: [StudyBinding(), ChapterDetailBinding()],
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfilePage(),
      bindings: [ProfileBinding(), EditProfileBinding()],
    ),
    GetPage(
      name: AppRoutes.subscription,
      page: () => const SubscriptionPage(),
      binding: SubscriptionBinding(),
    ),
  ];
}
