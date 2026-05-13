import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/helpers/app_colors.dart';
import 'package:pokemon_explorer/presentation/splash/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.catching_pokemon,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              'app_name'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
