import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pokemon_explorer/helpers/constants.dart';

class SettingsService extends GetxService {
  final _box = GetStorage();

  Future<SettingsService> init() async {
    return this;
  }

  // Theme Logic
  ThemeMode get themeMode {
    final bool? isDark = _box.read(AppConstants.keyIsDarkMode);
    if (isDark == null) return ThemeMode.system;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    final bool isDark = themeMode == ThemeMode.dark;
    Get.changeThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
    _box.write(AppConstants.keyIsDarkMode, !isDark);
  }

  // Language Logic
  Locale get locale {
    final String? langCode = _box.read(AppConstants.keyLanguage);
    if (langCode == null) return Get.deviceLocale ?? const Locale('en', 'US');
    return Locale(langCode);
  }

  void updateLocale(String langCode) {
    final locale = Locale(langCode);
    Get.updateLocale(locale);
    _box.write(AppConstants.keyLanguage, langCode);
  }
}
