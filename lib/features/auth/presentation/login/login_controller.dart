import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/services/auth_service.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
import 'package:pokemon_explorer/core/widgets/app_snackbar.dart';

class LoginController extends GetxController {
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to changes to validate the form in real-time
    userController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final user = userController.text.trim();
    final pass = passwordController.text.trim();

    // Condition: Both fields must have at least 4 characters
    isFormValid.value = user.length >= 4 && pass.length >= 4;
  }

  void login() {
    FocusScope.of(Get.context!).unfocus();

    final user = userController.text.trim();
    final pass = passwordController.text.trim();

    if (user == 'flutter' && pass == 'flutter') {
      AuthService.to.login(user, pass);
    } else {
      AppSnackbar.error(
        title: TranslationKeys.login.tr,
        message: TranslationKeys.invalidCredentials.tr,
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
