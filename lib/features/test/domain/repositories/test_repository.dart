import '../../data/models/start_test_model.dart';
import '../../data/models/submit_test_model.dart';
import '../../data/models/test_detail_model.dart';
import '../../data/models/test_list_model.dart';

abstract class TestRepository {
  Future<TestListModel> getTests();
  Future<TestDetailModel> getTestByNumber(int testNumber);
  Future<StartTestModel> startTest(int testNumber);
  Future<SubmitTestModel> submitTest({
    required int testNumber,
    required List<Map<String, String?>> answers,
    required int timeTaken,
  });
}
