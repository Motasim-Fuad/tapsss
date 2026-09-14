import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/json_parsers.dart';
import '../models/start_test_model.dart';
import '../models/submit_test_model.dart';
import '../models/test_detail_model.dart';
import '../models/test_list_model.dart';

class TestRemoteDataSource {
  final ApiClient apiClient;

  TestRemoteDataSource(this.apiClient);

  Future<TestListModel> getTests() async {
    final response = await apiClient.get(ApiEndpoints.tests);
    return TestListModel.fromJson(asJsonMap(response.data));
  }

  Future<TestDetailModel> getTestByNumber(int testNumber) async {
    final response = await apiClient.get(ApiEndpoints.testByNumber(testNumber));
    return TestDetailModel.fromJson(asJsonMap(response.data['test']));
  }

  Future<StartTestModel> startTest(int testNumber) async {
    final response = await apiClient.get(ApiEndpoints.startTest(testNumber));
    return StartTestModel.fromJson(asJsonMap(response.data));
  }

  Future<SubmitTestModel> submitTest({
    required int testNumber,
    required List<Map<String, String?>> answers,
    required int timeTaken,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.submitTest(testNumber),
      data: {'answers': answers, 'timeTaken': timeTaken},
    );
    return SubmitTestModel.fromJson(asJsonMap(response.data));
  }
}
