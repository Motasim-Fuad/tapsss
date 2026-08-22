import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/faq_model.dart';
import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSource(this.apiClient);

  Future<ProfileModel> getProfile() async {
    final response = await apiClient.get(ApiEndpoints.profile);
    return ProfileModel.fromJson(response.data);
  }

  Future<ProfileModel> updateProfile({required String name, String? imagePath}) async {
    final formData = FormData.fromMap({
      'name': name,
      if (imagePath != null) 'profile_pic': await MultipartFile.fromFile(imagePath),
    });

    final response = await apiClient.patch(ApiEndpoints.profile, data: formData);
    return ProfileModel.fromJson(response.data);
  }

  Future<List<FaqModel>> getFaqs() async {
    final response = await apiClient.get(ApiEndpoints.faqs);
    final list = response.data['faqs'];
    if (list is! List) return [];
    return list
        .whereType<Map>()
        .map((item) => FaqModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> deleteAccount() async {
    try {
      await apiClient.delete(ApiEndpoints.deleteAccount);
    } on ApiException catch (e) {
      if (e.statusCode == 404 || e.statusCode == 405) {
        await apiClient.post(ApiEndpoints.deleteAccount);
        return;
      }
      rethrow;
    }
  }
}
