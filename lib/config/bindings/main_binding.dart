import 'package:get/get.dart';
import '../../features/home/presentation/bindings/home_binding.dart';
import '../../features/profile/presentation/bindings/profile_binding.dart';
import '../../features/progress/presentation/bindings/progress_binding.dart';
import '../../features/study/presentation/bindings/study_binding.dart';
import '../../features/test/presentation/bindings/test_binding.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    HomeBinding().dependencies();
    TestBinding().dependencies();
    StudyBinding().dependencies();
    ProgressBinding().dependencies();
    ProfileBinding().dependencies();
  }
}
