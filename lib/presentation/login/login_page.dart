import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/presentation/widgets/rotating_pokeball.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Stack(
        children: [
          // Background Aesthetic
          Positioned(
            top: -100,
            right: -100,
            child: RotatingPokeball(
              size: 400,
              opacity: 0.05,
              color: colorScheme.primary,
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Title Area
                  Icon(Icons.catching_pokemon, size: 80, color: colorScheme.primary),
                  const SizedBox(height: 20),
                  Text(
                    'app_name'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Inicia sesión para continuar tu aventura',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colorScheme.onBackground.withOpacity(0.6)),
                  ),
                  const SizedBox(height: 60),

                  // Input Fields
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
                  const SizedBox(height: 40),

                  // Login Button
                  ElevatedButton(
                    onPressed: () => controller.login(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: Text(
                      'login'.tr.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: colorScheme.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
