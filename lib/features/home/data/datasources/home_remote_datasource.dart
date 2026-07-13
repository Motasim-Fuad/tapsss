import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/dashboard_model.dart';

class HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSource(this.apiClient);

  Future<DashboardModel> getDashboard() async {
    final response = await apiClient.get(ApiEndpoints.dashboard);
    return DashboardModel.fromJson(response.data['data'] ?? {});
  }
}
