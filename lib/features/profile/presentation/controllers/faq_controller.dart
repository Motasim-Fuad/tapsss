import 'package:get/get.dart';

import '../../../../core/error/exceptions.dart';
import '../../data/models/faq_model.dart';
import '../../domain/repositories/profile_repository.dart';

class FaqController extends GetxController {
  final ProfileRepository profileRepository;

  FaqController({required this.profileRepository});

  final RxList<FaqModel> faqs = <FaqModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      faqs.assignAll(await profileRepository.getFaqs());
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.'.tr;
    } finally {
      isLoading.value = false;
    }
  }
}
