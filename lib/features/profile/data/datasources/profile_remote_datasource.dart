import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
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
}
