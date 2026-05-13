import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsService extends GetxService {
  static SettingsService get to => Get.find();
  final _storage = GetStorage();

  // Observable states
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;
  final Rx<Color> _accentColor = Rx<Color>(Colors.grey); 
  final RxInt _gridColumns = 0.obs; 
  final RxBool _useCache = true.obs;
  final RxString _profileAvatar = 'assets/avatars/trainer_m.png'.obs;
  final Rx<Locale> _locale = const Locale('es', 'ES').obs;

  ThemeMode get themeMode => _themeMode.value;
  Color get accentColor => _accentColor.value;
  int get gridColumns => _gridColumns.value;
  bool get useCache => _useCache.value;
  String get profileAvatar => _profileAvatar.value;
  Locale get locale => _locale.value;

  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  // Essential for dependency injection
  Future<SettingsService> init() async {
    _loadSettings();
    return this;
  }

  void _loadSettings() {
    // Theme
    final savedTheme = _storage.read('theme_mode');
    if (savedTheme != null) {
      _themeMode.value = ThemeMode.values.firstWhere((e) => e.toString() == savedTheme);
    }

    // Color
    final savedColor = _storage.read('accent_color');
    if (savedColor != null) {
      _accentColor.value = Color(savedColor);
    }

    // Columns
    final savedColumns = _storage.read('grid_columns');
    if (savedColumns != null) {
      _gridColumns.value = savedColumns;
    }

    // Cache
    final savedCache = _storage.read('use_cache');
    if (savedCache != null) {
      _useCache.value = savedCache;
    }

    // Avatar
    final savedAvatar = _storage.read('profile_avatar');
    if (savedAvatar != null) {
      _profileAvatar.value = savedAvatar;
    }

    // Locale
    final langCode = _storage.read('lang_code');
    final countryCode = _storage.read('country_code');
    if (langCode != null && countryCode != null) {
      _locale.value = Locale(langCode, countryCode);
    }
  }

  void updateThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    _storage.write('theme_mode', mode.toString());
  }

  void toggleTheme() {
    updateThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  void updateAccentColor(Color color) {
    _accentColor.value = color;
    _storage.write('accent_color', color.value);
    Get.forceAppUpdate();
  }

  void updateGridColumns(int count) {
    _gridColumns.value = count;
    _storage.write('grid_columns', count);
  }

  void updateUseCache(bool value) {
    _useCache.value = value;
    _storage.write('use_cache', value);
  }

  void updateAvatar(String path) {
    _profileAvatar.value = path;
    _storage.write('profile_avatar', path);
  }

  void updateLocale(Locale loc) {
    _locale.value = loc;
    Get.updateLocale(loc);
    _storage.write('lang_code', loc.languageCode);
    _storage.write('country_code', loc.countryCode);
  }

  int getCachedCount() {
    final allKeys = _storage.getKeys();
    return allKeys.where((key) => key.toString().startsWith('pokemon_item_')).length;
  }

  void clearCache() {
    final allKeys = _storage.getKeys().toList();
    for (var key in allKeys) {
      if (key.toString().startsWith('pokemon_item_')) {
        _storage.remove(key);
      }
    }
  }
}
