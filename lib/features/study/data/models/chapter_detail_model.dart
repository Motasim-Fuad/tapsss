import '../../../../core/utils/json_parsers.dart';

class ParagraphModel {
  final String id;
  final int order;
  final String content;

  ParagraphModel({required this.id, required this.order, required this.content});

  factory ParagraphModel.fromJson(Map<String, dynamic> json) {
    return ParagraphModel(
      id: asString(json['_id']),
      order: asInt(json['paragraphOrder']),
      content: asString(json['content']),
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
      id: asString(json['_id']),
      order: asInt(json['lessonOrder']),
      heading: asString(json['heading']),
      lessonImage: json['lessonImage']?.toString(),
      paragraphs: asJsonMapList(json['paragraphs'])
          .map(ParagraphModel.fromJson)
          .toList(),
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
      id: asString(json['_id']),
      chapterNumber: asInt(json['chapterNumber']),
      title: asString(json['title']),
      subtitle: asString(json['subtitle']),
      coverImage: asString(json['coverImage']),
      totalLessons: asInt(json['totalLessons']),
      completedLessons: asInt(json['completedLessons']),
      progressPercentage: asInt(json['progressPercentage']),
      isChapterCompleted: json['isChapterCompleted'] == true,
      lessons: asJsonMapList(json['lessons']).map(LessonModel.fromJson).toList(),
      completedLessonIds: (json['completedLessonIds'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}
