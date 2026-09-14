import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/api_endpoints.dart';
import '../constants/storage_keys.dart';
import '../network/api_client.dart';
import '../services/preference_service.dart';

class LocaleService {
  LocaleService._();

  static const Locale english = Locale('en', 'US');
  static const Locale swedish = Locale('sv', 'SE');

  static Locale get initialLocale {
    return PreferenceService.instance.getString(StorageKeys.language) == 'en'
        ? english
        : swedish;
  }

  static String get currentLanguageCode {
    final code = PreferenceService.instance.getString(StorageKeys.language);
    return code == 'en' ? 'en' : 'sv';
  }

  static Future<void> changeLanguage(String languageCode) async {
    final lang = languageCode == 'sv' ? 'sv' : 'en';

    final apiClient = Get.find<ApiClient>();

    await apiClient.patch(
      ApiEndpoints.changeLanguage,
      data: {'lang': lang},
    );

    await PreferenceService.instance.setString(
      StorageKeys.language,
      lang,
    );

    await Get.updateLocale(
      lang == 'sv' ? swedish : english,
    );

    Get.forceAppUpdate();
  }
}
