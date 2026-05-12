class AppConstants {
  static const String appName = 'Pokémon Explorer';
  static const String baseUrl = 'https://pokeapi.co/api/v2';
  
  // Storage Keys
  static const String keyIsDarkMode = 'is_dark_mode';
  static const String keyLanguage = 'language';
  static const String keyFavorites = 'favorites';
  
  // Pagination
  static const int pokemonLimit = 20;
}

class Endpoints {
  static const String pokemon = '/pokemon';
  static String pokemonDetail(String nameOrId) => '/pokemon/$nameOrId';
}
