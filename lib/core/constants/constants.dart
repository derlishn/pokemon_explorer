import 'package:pokemon_explorer/core/constants/translation_keys.dart';

class AppConstants {
  static const String appName = 'Pokémon Explorer';

  // Storage Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserName = 'user_name';
  static const String keyUserPassword = 'user_password';
  static const String keyFavorites = 'favorites_objects_list';
  static const String keyThemeMode = 'theme_mode';
  static const String keyAccentColor = 'accent_color';
  static const String keyGridColumns = 'grid_columns';
  static const String keyUseCache = 'use_cache';
  static const String keyProfileAvatar = 'profile_avatar';
  static const String keyLangCode = 'lang_code';
  static const String keyCountryCode = 'country_code';
  
  // Prefixes
  static const String pokemonCachePrefix = 'pokemon_item_';

  // Default Values
  static const String defaultUserName = 'Guest';
  static const String defaultAvatar = 'assets/avatars/trainer_m.png';
  static const String defaultLanguageCode = 'es';
  static const String defaultCountryCode = 'ES';
  static const String defaultThemeMode = 'ThemeMode.light';

  // Exports
  static const translationKeys = TranslationKeys;
}
