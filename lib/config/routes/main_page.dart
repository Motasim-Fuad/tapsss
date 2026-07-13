import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/study/presentation/pages/study_page.dart';
import '../../features/test/presentation/pages/test_list_page.dart';
import '../../shared/widgets/custom_bottom_nav.dart';

class MainController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());

    const pages = [
      HomePage(),
      TestListPage(),
      StudyPage(),
      ProgressPage(),
      ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() => IndexedStack(index: controller.currentIndex.value, children: pages)),
      bottomNavigationBar: Obx(() => CustomBottomNav(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
          )),
    );
  }
}
