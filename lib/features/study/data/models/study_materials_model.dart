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
      totalChapters: json['totalChapters'] ?? 0,
      completedChapters: json['completedChapters'] ?? 0,
      totalLessons: json['totalLessons'] ?? 0,
      completedLessons: json['completedLessons'] ?? 0,
      progressPercentage: json['progressPercentage'] ?? 0,
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
      id: json['_id']?.toString() ?? '',
      chapterNumber: json['chapterNumber'] ?? 0,
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? '',
      totalLessons: json['totalLessons'] ?? 0,
      completedLessons: json['completedLessons'] ?? 0,
      progressPercentage: json['progressPercentage'] ?? 0,
      isChapterCompleted: json['isChapterCompleted'] == true,
    );
  }
}

class StudyMaterialsModel {
  final OverallProgressModel overallProgress;
  final List<ChapterModel> chapters;

  StudyMaterialsModel({required this.overallProgress, required this.chapters});

  factory StudyMaterialsModel.fromJson(Map<String, dynamic> json) {
    return StudyMaterialsModel(
      overallProgress: OverallProgressModel.fromJson(json['overallProgress'] ?? {}),
      chapters: (json['chapters'] as List? ?? []).map((e) => ChapterModel.fromJson(e)).toList(),
    );
  }
}
