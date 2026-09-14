import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/json_parsers.dart';
import '../models/progress_models.dart';

class ProgressRemoteDataSource {
  final ApiClient apiClient;

  ProgressRemoteDataSource(this.apiClient);

  Future<ProgressOverviewModel> getOverview() async {
    final response = await apiClient.get(ApiEndpoints.progressOverview);
    return ProgressOverviewModel.fromJson(asJsonMap(response.data['data']));
  }

  Future<List<TestHistoryItemModel>> getTestHistory() async {
    final response = await apiClient.get(ApiEndpoints.testHistory);
    return asJsonMapList(response.data['tests'])
        .map(TestHistoryItemModel.fromJson)
        .toList();
  }

  Future<List<ScoreHistoryPointModel>> getScoreHistory(String period) async {
    final response = await apiClient.get(
      ApiEndpoints.scoreHistory,
      query: {'period': period},
    );
    return asJsonMapList(response.data['data'])
        .map(ScoreHistoryPointModel.fromJson)
        .toList();
  }
}
