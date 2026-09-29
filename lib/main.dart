import 'package:arashmati_app/core/services/observability.dart';
import 'package:arashmati_app/core/services/preference_service.dart';
import 'package:arashmati_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'config/bindings/initial_binding.dart';
import 'config/routes/app_pages.dart';
import 'config/routes/app_routes.dart';
import 'core/constants/app_colors.dart';
import 'core/localization/app_translations.dart';
import 'core/localization/locale_service.dart';
import 'core/services/notification_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Observability.start();

  await Get.putAsync(() async => await NotificationService().init());
  await PreferenceService.instance.init();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  if (Observability.sentryEnabled) {
    await SentryFlutter.init(
      Observability.configureSentry,
      appRunner: () {
        Observability.bindErrorHandlers();
        runApp(const ArashmatiApp());
      },
    );
    return;
  }

  Observability.bindErrorHandlers();
  runApp(const ArashmatiApp());
}

class ArashmatiApp extends StatelessWidget {
  const ArashmatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sweden Citizenship Test',
      translations: AppTranslations(),
      locale: LocaleService.initialLocale,
      fallbackLocale: LocaleService.swedish,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 320),
      navigatorObservers: Observability.navigatorObservers,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 0,
        ),
      ),
    );
  }
}
