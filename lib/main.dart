import 'package:arashmati_app/core/services/preference_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'config/bindings/initial_binding.dart';
import 'config/routes/app_pages.dart';
import 'config/routes/app_routes.dart';
import 'core/constants/app_colors.dart';
import 'core/localization/app_translations.dart';
import 'core/localization/locale_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await PreferenceService.instance.init();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

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
      fallbackLocale: LocaleService.english,
      debugShowCheckedModeBanner: false,
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
