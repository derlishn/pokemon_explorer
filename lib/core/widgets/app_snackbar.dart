import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  /// Shows a success snackbar (Green theme)
  static void success({required String title, required String message}) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }

  /// Shows an error snackbar (Red theme)
  static void error({required String title, required String message}) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.redAccent,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  /// Shows an info/warning snackbar (Blue/Amber theme)
  static void info({required String title, required String message}) {
    _show(
      title: title,
      message: message,
      backgroundColor: Get.theme.colorScheme.secondary,
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    required Widget icon,
  }) {
    // Determine max width based on screen size (Responsive logic)
    final bool isLargeScreen = Get.width > 600;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor.withValues(alpha: 0.9),
      colorText: Colors.white,
      icon: icon,
      margin: EdgeInsets.symmetric(
        horizontal: isLargeScreen ? (Get.width - 400) / 2 : 20,
        vertical: 20,
      ),
      borderRadius: 16,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}
