import 'dart:ui';

import 'package:get/get.dart';

import '../constants/storage_keys.dart';
import '../services/preference_service.dart';

class LocaleService {
  LocaleService._();

  static const Locale english = Locale('en', 'US');
  static const Locale swedish = Locale('sv', 'SE');

  static Locale get initialLocale {
    return PreferenceService.instance.getString(StorageKeys.language) == 'sv'
        ? swedish
        : english;
  }

  static Future<void> changeLanguage(String languageCode) async {
    final locale = languageCode == 'sv' ? swedish : english;
    await PreferenceService.instance.setString(StorageKeys.language, languageCode);
    Get.updateLocale(locale);
  }
}
