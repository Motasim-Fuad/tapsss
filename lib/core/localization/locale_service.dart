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
    return PreferenceService.instance.getString(StorageKeys.language) == 'sv'
        ? swedish
        : english;
  }

  static String get currentLanguageCode {
    final code = PreferenceService.instance.getString(StorageKeys.language);
    return code == 'sv' ? 'sv' : 'en';
  }

  /// Changes the user's language on the backend first.
  ///
  /// English -> {"lang":"en"}
  /// Swedish -> {"lang":"sv"}
  ///
  /// Static Flutter translations are updated only after the API succeeds.
  /// Backend-driven content remains the backend's responsibility.
  static Future<void> changeLanguage(String languageCode) async {
    final lang = languageCode == 'sv' ? 'sv' : 'en';

    final apiClient = Get.find<ApiClient>();

    // Backend language preference is the source of truth.
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
