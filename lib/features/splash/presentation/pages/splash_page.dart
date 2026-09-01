import 'package:arashmati_app/features/splash/presentation/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/lottie/morphing_particle_loader.json',
          controller: _lottieController,
          width: 280,
          height: 280,
          fit: BoxFit.contain,
          onLoaded: (composition) {
            _lottieController.duration = composition.duration;
            _lottieController.forward().whenComplete(controller.goNext);
          },
        ),
      ),
    );
  }
}
