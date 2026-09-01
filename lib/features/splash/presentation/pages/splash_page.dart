import 'package:arashmati_app/features/splash/presentation/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/lottie/morphing_particle_loader.json',
          width: 280,
          height: 280,
          fit: BoxFit.contain,
          repeat: true,
        ),
      ),
    );
  }
}
