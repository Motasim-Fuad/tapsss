import 'package:arashmati_app/features/splash/presentation/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    print("SplashPage build");
    print(controller);

    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/app_mobile_logo.png"),
      ),
    );
  }
}
