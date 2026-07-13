import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_remote_datasource.dart';
import '../models/progress_models.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDataSource remoteDataSource;

  ProgressRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProgressOverviewModel> getOverview() => remoteDataSource.getOverview();

  @override
  Future<List<TestHistoryItemModel>> getTestHistory() => remoteDataSource.getTestHistory();

  @override
  Future<List<ScoreHistoryPointModel>> getScoreHistory(String period) =>
      remoteDataSource.getScoreHistory(period);
}
