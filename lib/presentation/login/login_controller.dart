import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/services/auth_service.dart';
import 'package:pokemon_explorer/presentation/widgets/app_snackbar.dart';

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
      AppSnackbar.error(
        title: 'login'.tr,
        message: 'invalid_credentials'.tr,
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
