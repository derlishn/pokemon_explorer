import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/services/auth_service.dart';

class LoginController extends GetxController {
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    final user = userController.text.trim();
    final pass = passwordController.text.trim();

    if (user.isNotEmpty && pass.isNotEmpty) {
      // For this demo, any non-empty credentials work
      AuthService.to.login(user);
    } else {
      Get.snackbar(
        'login'.tr,
        'invalid_credentials'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  @override
  void onClose() {
    userController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
