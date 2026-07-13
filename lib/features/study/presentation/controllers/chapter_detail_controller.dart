import 'package:get/get.dart';
import '../../../../core/error/exceptions.dart';
import '../../data/models/chapter_detail_model.dart';
import '../../domain/repositories/study_repository.dart';

class ChapterDetailController extends GetxController {
  final StudyRepository studyRepository;

  ChapterDetailController({required this.studyRepository});

  late final String chapterId;

  final Rxn<ChapterDetailModel> chapter = Rxn<ChapterDetailModel>();
  final RxInt currentLessonIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isMarking = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    chapterId = args['chapterId']?.toString() ?? '';
    fetchChapter();
  }

  Future<void> fetchChapter() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final data = await studyRepository.getChapterDetails(chapterId);
      chapter.value = data;
      final firstIncomplete = data.lessons.indexWhere(
        (lesson) => !data.completedLessonIds.contains(lesson.id),
      );
      currentLessonIndex.value = firstIncomplete == -1 ? 0 : firstIncomplete;
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  bool get isLastLesson =>
      chapter.value != null && currentLessonIndex.value >= chapter.value!.lessons.length - 1;

  void nextLesson() {
    if (chapter.value == null) return;
    if (!isLastLesson) {
      currentLessonIndex.value++;
    } else {
      markComplete();
    }
  }

  Future<void> markComplete() async {
    errorMessage.value = null;
    isMarking.value = true;
    try {
      await studyRepository.markChapterComplete(chapterId);
      Get.back();
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isMarking.value = false;
    }
  }
}
