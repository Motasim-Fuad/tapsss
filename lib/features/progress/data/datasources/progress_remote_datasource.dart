import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/progress_models.dart';

class ProgressRemoteDataSource {
  final ApiClient apiClient;

  ProgressRemoteDataSource(this.apiClient);

  Future<ProgressOverviewModel> getOverview() async {
    final response = await apiClient.get(ApiEndpoints.progressOverview);
    return ProgressOverviewModel.fromJson(response.data['data'] ?? {});
  }

  Future<List<TestHistoryItemModel>> getTestHistory() async {
    final response = await apiClient.get(ApiEndpoints.testHistory);
    return (response.data['tests'] as List? ?? [])
        .map((e) => TestHistoryItemModel.fromJson(e))
        .toList();
  }

  Future<List<ScoreHistoryPointModel>> getScoreHistory(String period) async {
    final response = await apiClient.get(ApiEndpoints.scoreHistory, query: {'period': period});
    return (response.data['data'] as List? ?? [])
        .map((e) => ScoreHistoryPointModel.fromJson(e))
        .toList();
  }
}
