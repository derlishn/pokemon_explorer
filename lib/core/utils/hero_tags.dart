class HeroTags {
  static const String homePrefix = 'home_list';
  static const String favoritesPrefix = 'fav_list';
  static const String detailPrefix = 'detail';

  /// Generates a unique hero tag for a pokemon in the home list
  static String getHomeTag(int id, int index) => '${homePrefix}_${id}_$index';

  /// Generates a unique hero tag for a pokemon in the favorites list
  static String getFavoriteTag(int id, int index) => '${favoritesPrefix}_${id}_$index';

  /// Default tag fallback
  static String getDefaultTag(int id) => '${detailPrefix}_$id';
}
