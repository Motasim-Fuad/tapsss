import '../../data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({required String name, String? imagePath});
}
