import '../../../../core/utils/json_parsers.dart';

class OverallProgressModel {
  final int totalChapters;
  final int completedChapters;
  final int totalLessons;
  final int completedLessons;
  final int progressPercentage;

  OverallProgressModel({
    required this.totalChapters,
    required this.completedChapters,
    required this.totalLessons,
    required this.completedLessons,
    required this.progressPercentage,
  });

  factory OverallProgressModel.fromJson(Map<String, dynamic> json) {
    return OverallProgressModel(
      totalChapters: asInt(json['totalChapters']),
      completedChapters: asInt(json['completedChapters']),
      totalLessons: asInt(json['totalLessons']),
      completedLessons: asInt(json['completedLessons']),
      progressPercentage: asInt(json['progressPercentage']),
    );
  }
}

class ChapterModel {
  final String id;
  final int chapterNumber;
  final String title;
  final String subtitle;
  final String coverImage;
  final int totalLessons;
  final int completedLessons;
  final int progressPercentage;
  final bool isChapterCompleted;

  ChapterModel({
    required this.id,
    required this.chapterNumber,
    required this.title,
    required this.subtitle,
    required this.coverImage,
    required this.totalLessons,
    required this.completedLessons,
    required this.progressPercentage,
    required this.isChapterCompleted,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: asString(json['_id']),
      chapterNumber: asInt(json['chapterNumber']),
      title: asString(json['title']),
      subtitle: asString(json['subtitle']),
      coverImage: asString(json['coverImage']),
      totalLessons: asInt(json['totalLessons']),
      completedLessons: asInt(json['completedLessons']),
      progressPercentage: asInt(json['progressPercentage']),
      isChapterCompleted: json['isChapterCompleted'] == true,
    );
  }
}

class StudyMaterialsModel {
  final OverallProgressModel overallProgress;
  final List<ChapterModel> chapters;

  StudyMaterialsModel({required this.overallProgress, required this.chapters});

  factory StudyMaterialsModel.fromJson(Map<String, dynamic> json) {
    final root = json['data'] is Map ? asJsonMap(json['data']) : json;
    return StudyMaterialsModel(
      overallProgress: OverallProgressModel.fromJson(
        asJsonMap(root['overallProgress']),
      ),
      chapters: asJsonMapList(root['chapters'])
          .map(ChapterModel.fromJson)
          .toList(),
    );
  }
}
