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
  final RxInt _gridColumns = 0.obs;
  
  // Neutral Color
  static final int neutralColorValue = Colors.grey.value;
  final RxInt _accentColorValue = neutralColorValue.obs;

  // Profile Avatar (Default Pikachu)
  final RxString _profileAvatar = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png'.obs;

  bool get isDarkMode => _isDarkMode.value;
  Locale get locale => _locale.value;
  int get gridColumns => _gridColumns.value;
  Color get accentColor => Color(_accentColorValue.value);
  String get profileAvatar => _profileAvatar.value;

  ThemeMode get themeMode {
    final bool? isDark = _box.read(AppConstants.keyIsDarkMode);
    if (isDark == null) return ThemeMode.system;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<SettingsService> init() async {
    _isDarkMode.value = _box.read(AppConstants.keyIsDarkMode) ?? false;
    _gridColumns.value = _box.read('grid_columns') ?? 0;
    _accentColorValue.value = _box.read('accent_color') ?? neutralColorValue;
    _profileAvatar.value = _box.read('profile_avatar') ?? 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png';
    
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

  void updateGridColumns(int count) {
    _gridColumns.value = count;
    _box.write('grid_columns', count);
  }

  void updateAccentColor(Color color) {
    _accentColorValue.value = color.value;
    _box.write('accent_color', color.value);
    Get.forceAppUpdate();
  }

  void updateAvatar(String url) {
    _profileAvatar.value = url;
    _box.write('profile_avatar', url);
  }
}
