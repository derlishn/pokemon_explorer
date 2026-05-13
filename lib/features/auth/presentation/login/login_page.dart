import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
import 'package:pokemon_explorer/features/auth/presentation/login/login_controller.dart';
import 'package:pokemon_explorer/features/auth/presentation/login/widgets/auth_text_field.dart';
import 'package:pokemon_explorer/features/auth/presentation/login/widgets/auth_button.dart';
import 'package:pokemon_explorer/features/auth/presentation/login/widgets/login_header.dart';
import 'package:pokemon_explorer/features/auth/presentation/login/widgets/login_background.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: const Stack(
          children: [
            // Background Aesthetic
            LoginBackground(),

            Center(
              child: SingleChildScrollView(
                child: _LoginContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal widget to keep the LoginPage even cleaner
class _LoginContent extends GetView<LoginController> {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginHeader(
            title: TranslationKeys.appName.tr,
            subtitle: TranslationKeys.loginSubtitle.tr,
          ),
          const SizedBox(height: 60),

          // Input Form
          AuthTextField(
            controller: controller.userController,
            hint: TranslationKeys.user.tr,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 20),
          AuthTextField(
            controller: controller.passwordController,
            hint: TranslationKeys.password.tr,
            icon: Icons.lock_outline,
            isPassword: true,
          ),
          const SizedBox(height: 48),

          // Login Button
          Obx(() => AuthButton(
                label: TranslationKeys.login.tr,
                onPressed: controller.isFormValid.value
                    ? () => controller.login()
                    : null,
              )),
        ],
      ),
    );
  }
}
