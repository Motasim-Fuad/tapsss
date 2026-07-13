import '../../data/models/chapter_detail_model.dart';
import '../../data/models/study_materials_model.dart';

abstract class StudyRepository {
  Future<StudyMaterialsModel> getStudyMaterials();
  Future<ChapterDetailModel> getChapterDetails(String chapterId);
  Future<void> markChapterComplete(String chapterId);
}
