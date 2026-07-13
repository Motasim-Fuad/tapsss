class ParagraphModel {
  final String id;
  final int order;
  final String content;

  ParagraphModel({required this.id, required this.order, required this.content});

  factory ParagraphModel.fromJson(Map<String, dynamic> json) {
    return ParagraphModel(
      id: json['_id']?.toString() ?? '',
      order: json['paragraphOrder'] ?? 0,
      content: json['content']?.toString() ?? '',
    );
  }
}

class LessonModel {
  final String id;
  final int order;
  final String heading;
  final String? lessonImage;
  final List<ParagraphModel> paragraphs;

  LessonModel({
    required this.id,
    required this.order,
    required this.heading,
    this.lessonImage,
    required this.paragraphs,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['_id']?.toString() ?? '',
      order: json['lessonOrder'] ?? 0,
      heading: json['heading']?.toString() ?? '',
      lessonImage: json['lessonImage']?.toString(),
      paragraphs:
          (json['paragraphs'] as List? ?? []).map((e) => ParagraphModel.fromJson(e)).toList(),
    );
  }
}

class ChapterDetailModel {
  final String id;
  final int chapterNumber;
  final String title;
  final String subtitle;
  final String coverImage;
  final int totalLessons;
  final int completedLessons;
  final int progressPercentage;
  final bool isChapterCompleted;
  final List<LessonModel> lessons;
  final List<String> completedLessonIds;

  ChapterDetailModel({
    required this.id,
    required this.chapterNumber,
    required this.title,
    required this.subtitle,
    required this.coverImage,
    required this.totalLessons,
    required this.completedLessons,
    required this.progressPercentage,
    required this.isChapterCompleted,
    required this.lessons,
    required this.completedLessonIds,
  });

  factory ChapterDetailModel.fromJson(Map<String, dynamic> json) {
    return ChapterDetailModel(
      id: json['_id']?.toString() ?? '',
      chapterNumber: json['chapterNumber'] ?? 0,
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? '',
      totalLessons: json['totalLessons'] ?? 0,
      completedLessons: json['completedLessons'] ?? 0,
      progressPercentage: json['progressPercentage'] ?? 0,
      isChapterCompleted: json['isChapterCompleted'] == true,
      lessons: (json['lessons'] as List? ?? []).map((e) => LessonModel.fromJson(e)).toList(),
      completedLessonIds:
          (json['completedLessonIds'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}
