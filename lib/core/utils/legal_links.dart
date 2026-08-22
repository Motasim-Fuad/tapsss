import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/api_endpoints.dart';

class LegalLinks {
  static Future<void> openTerms() => open(ApiEndpoints.termsUrl);

  static Future<void> openPrivacyPolicy() => open(ApiEndpoints.privacyPolicyUrl);

  static Future<void> open(String url) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      Get.snackbar('Error'.tr, 'Could not open the link.'.tr);
    }
  }
}
