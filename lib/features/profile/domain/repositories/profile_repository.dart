import '../../data/models/faq_model.dart';
import '../../data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({required String name, String? imagePath});
  Future<List<FaqModel>> getFaqs();
  Future<void> deleteAccount();
}
