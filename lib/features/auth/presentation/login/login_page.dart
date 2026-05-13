import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
import 'package:pokemon_explorer/core/widgets/rotating_pokeball.dart';
import 'package:pokemon_explorer/features/auth/presentation/login/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
          // Background Aesthetic (Top Right)
          Positioned(
            top: -100,
            right: -100,
            child: RotatingPokeball(
              size: 400,
              opacity: 0.05,
              color: colorScheme.primary,
            ),
          ),
          
          // Background Aesthetic (Bottom Left) - Adding symmetry for desktop
          Positioned(
            bottom: -150,
            left: -150,
            child: RotatingPokeball(
              size: 500,
              opacity: 0.03,
              color: colorScheme.primary,
            ),
          ),
          
          Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo Area
                    Hero(
                      tag: 'login_logo',
                      child: Icon(Icons.catching_pokemon, size: 100, color: colorScheme.primary),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      TranslationKeys.appName.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Inicia sesión para continuar tu aventura',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Input Form
                    _buildTextField(
                      controller: controller.userController,
                      hint: 'user'.tr,
                      icon: Icons.person_outline,
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: controller.passwordController,
                      hint: 'password'.tr,
                      icon: Icons.lock_outline,
                      isPassword: true,
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 48),

                    // Login Button
                    Obx(() => ElevatedButton(
                      onPressed: controller.isFormValid.value 
                          ? () => controller.login() 
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                        disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: controller.isFormValid.value ? 4 : 0,
                        shadowColor: colorScheme.primary.withValues(alpha: 0.4),
                      ),
                      child: Text(
                        TranslationKeys.login.tr.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold, 
                          letterSpacing: 2.0,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required ColorScheme colorScheme,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: colorScheme.onSurfaceVariant),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
          prefixIcon: Icon(icon, color: colorScheme.primary, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}
