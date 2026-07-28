import '../../domain/repositories/test_repository.dart';
import '../datasources/test_remote_datasource.dart';
import '../models/start_test_model.dart';
import '../models/submit_test_model.dart';
import '../models/test_detail_model.dart';
import '../models/test_list_model.dart';

class TestRepositoryImpl implements TestRepository {
  final TestRemoteDataSource remoteDataSource;

  TestRepositoryImpl(this.remoteDataSource);

  @override
  Future<TestListModel> getTests() => remoteDataSource.getTests();

  @override
  Future<TestDetailModel> getTestByNumber(int testNumber) =>
      remoteDataSource.getTestByNumber(testNumber);

  @override
  Future<StartTestModel> startTest(int testNumber) => remoteDataSource.startTest(testNumber);

  @override
  Future<SubmitTestModel> submitTest({
    required int testNumber,
    required List<Map<String, String?>> answers,
    required int timeTaken,
  }) {
    return remoteDataSource.submitTest(testNumber: testNumber, answers: answers, timeTaken: timeTaken);
  }


}
