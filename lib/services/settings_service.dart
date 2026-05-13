import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/storage/storage_service.dart';
import 'package:pokemon_explorer/core/constants/constants.dart';
import 'package:pokemon_explorer/services/favorites_service.dart';

class SettingsService extends GetxService {
  static SettingsService get to => Get.find();
  final StorageService storageService;

  SettingsService({required this.storageService});

  // Observable states
  final Rx<ThemeMode> _themeMode = ThemeMode.values.firstWhere(
    (e) => e.toString() == AppConstants.defaultThemeMode,
    orElse: () => ThemeMode.light,
  ).obs;
  final Rx<Color> _accentColor = Rx<Color>(Colors.grey); 
  final RxInt _gridColumns = 0.obs; 
  final RxBool _useCache = true.obs;
  final RxString _profileAvatar = AppConstants.defaultAvatar.obs;
  final RxInt _refreshSignal = 0.obs; // Signal to refresh Home on cache clear
  final Rx<Locale> _locale = const Locale(
    AppConstants.defaultLanguageCode,
    AppConstants.defaultCountryCode,
  ).obs;

  ThemeMode get themeMode => _themeMode.value;
  Color get accentColor => _accentColor.value;
  int get gridColumns => _gridColumns.value;
  bool get useCache => _useCache.value;
  String get profileAvatar => _profileAvatar.value;
  RxInt get refreshSignalRx => _refreshSignal;
  Locale get locale => _locale.value;

  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  Future<SettingsService> init() async {
    _loadSettings();
    return this;
  }

  void _loadSettings() {
    // Theme
    final savedTheme = storageService.read<String>(AppConstants.keyThemeMode);
    if (savedTheme != null) {
      _themeMode.value = ThemeMode.values.firstWhere((e) => e.toString() == savedTheme);
    }

    // Color
    final savedColor = storageService.read<int>(AppConstants.keyAccentColor);
    if (savedColor != null) {
      _accentColor.value = Color(savedColor);
    }

    // Columns
    final savedColumns = storageService.read<int>(AppConstants.keyGridColumns);
    if (savedColumns != null) {
      _gridColumns.value = savedColumns;
    }

    // Cache
    final savedCache = storageService.read<bool>(AppConstants.keyUseCache);
    if (savedCache != null) {
      _useCache.value = savedCache;
    }

    // Avatar
    final savedAvatar = storageService.read<String>(AppConstants.keyProfileAvatar);
    if (savedAvatar != null) {
      _profileAvatar.value = savedAvatar;
    }

    // Locale
    final langCode = storageService.read<String>(AppConstants.keyLangCode);
    final countryCode = storageService.read<String>(AppConstants.keyCountryCode);
    if (langCode != null && countryCode != null) {
      _locale.value = Locale(langCode, countryCode);
    }
  }

  void updateThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    storageService.write(AppConstants.keyThemeMode, mode.toString());
  }

  void toggleTheme() {
    updateThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  void updateAccentColor(Color color) {
    _accentColor.value = color;
    storageService.write(AppConstants.keyAccentColor, color.toARGB32());
    Get.forceAppUpdate();
  }

  void updateGridColumns(int count) {
    _gridColumns.value = count;
    storageService.write(AppConstants.keyGridColumns, count);
  }

  void updateUseCache(bool value) {
    _useCache.value = value;
    storageService.write(AppConstants.keyUseCache, value);
  }

  void updateAvatar(String path) {
    _profileAvatar.value = path;
    storageService.write(AppConstants.keyProfileAvatar, path);
  }

  void updateLocale(Locale loc) {
    _locale.value = loc;
    Get.updateLocale(loc);
    storageService.write(AppConstants.keyLangCode, loc.languageCode);
    storageService.write(AppConstants.keyCountryCode, loc.countryCode);
  }

  int getCachedCount() {
    final allKeys = storageService.getKeys();
    return allKeys
        .where((key) => key.toString().startsWith(AppConstants.pokemonCachePrefix))
        .length;
  }

  void clearCache() {
    final allKeys = storageService.getKeys().toList();
    for (var key in allKeys) {
      final k = key.toString();
      if (k.startsWith(AppConstants.pokemonCachePrefix) || 
          k.startsWith(AppConstants.keyPokemonListPrefix) ||
          k.startsWith(AppConstants.pokemonDetailCachePrefix)) {
        storageService.remove(k);
      }
    }
    _refreshSignal.value++; // Notify Home to reload
    FavoritesService.to.clearAll(); // Also clear favorites
  }
}
