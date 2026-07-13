import '../../data/models/progress_models.dart';

abstract class ProgressRepository {
  Future<ProgressOverviewModel> getOverview();
  Future<List<TestHistoryItemModel>> getTestHistory();
  Future<List<ScoreHistoryPointModel>> getScoreHistory(String period);
}
