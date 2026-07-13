import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/chapter_detail_model.dart';
import '../models/study_materials_model.dart';

class StudyRemoteDataSource {
  final ApiClient apiClient;

  StudyRemoteDataSource(this.apiClient);

  Future<StudyMaterialsModel> getStudyMaterials() async {
    final response = await apiClient.get(ApiEndpoints.studyMaterials);
    return StudyMaterialsModel.fromJson(response.data);
  }

  Future<ChapterDetailModel> getChapterDetails(String chapterId) async {
    final response = await apiClient.get(ApiEndpoints.chapterDetails(chapterId));
    return ChapterDetailModel.fromJson(response.data['chapter'] ?? {});
  }

  Future<void> markChapterComplete(String chapterId) async {
    await apiClient.post(ApiEndpoints.markChapterComplete, data: {'chapterId': chapterId});
  }
}
