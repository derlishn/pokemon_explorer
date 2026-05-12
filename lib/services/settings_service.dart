import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pokemon_explorer/helpers/constants.dart';

class SettingsService extends GetxService {
  static SettingsService get to => Get.find();
  
  final _box = GetStorage();
  
  // Reactive states
  final RxBool _isDarkMode = false.obs;
  final Rx<Locale> _locale = const Locale('en', 'US').obs;

  bool get isDarkMode => _isDarkMode.value;
  Locale get locale => _locale.value;

  ThemeMode get themeMode {
    final bool? isDark = _box.read(AppConstants.keyIsDarkMode);
    if (isDark == null) return ThemeMode.system;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<SettingsService> init() async {
    // Initialize reactive states from storage
    _isDarkMode.value = _box.read(AppConstants.keyIsDarkMode) ?? false;
    
    final String? langCode = _box.read(AppConstants.keyLanguage);
    if (langCode != null) {
      _locale.value = Locale(langCode);
    } else {
      _locale.value = Get.deviceLocale ?? const Locale('en', 'US');
    }
    
    return this;
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _box.write(AppConstants.keyIsDarkMode, _isDarkMode.value);
  }

  void updateLocale(Locale newLocale) {
    _locale.value = newLocale;
    Get.updateLocale(newLocale);
    _box.write(AppConstants.keyLanguage, newLocale.languageCode);
  }
}
