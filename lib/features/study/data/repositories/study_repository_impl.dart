import '../../domain/repositories/study_repository.dart';
import '../datasources/study_remote_datasource.dart';
import '../models/chapter_detail_model.dart';
import '../models/study_materials_model.dart';

class StudyRepositoryImpl implements StudyRepository {
  final StudyRemoteDataSource remoteDataSource;

  StudyRepositoryImpl(this.remoteDataSource);

  @override
  Future<StudyMaterialsModel> getStudyMaterials() => remoteDataSource.getStudyMaterials();

  @override
  Future<ChapterDetailModel> getChapterDetails(String chapterId) =>
      remoteDataSource.getChapterDetails(chapterId);

  @override
  Future<void> markChapterComplete(String chapterId) =>
      remoteDataSource.markChapterComplete(chapterId);
}
