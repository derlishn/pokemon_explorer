class ApiConstants {
  static const String baseUrl = 'https://pokeapi.co/api/v2';
  
  // Timeouts
  static const int receiveTimeout = 45; // seconds
  static const int connectTimeout = 45; // seconds
  
  // Endpoints
  static const String pokemonEndpoint = '/pokemon';
  
  // Query Parameters
  static const String paramLimit = 'limit';
  static const String paramOffset = 'offset';
  
  // JSON Keys
  static const String keyId = 'id';
  static const String keyName = 'name';
  static const String keyUrl = 'url';
  static const String keyTypes = 'types';
  static const String keyType = 'type';
  static const String keyStats = 'stats';
  static const String keyStat = 'stat';
  static const String keyBaseStat = 'base_stat';
  static const String keyAbilities = 'abilities';
  static const String keyAbility = 'ability';
  static const String keyHeight = 'height';
  static const String keyWeight = 'weight';
  static const String keyBaseExperience = 'base_experience';
  static const String keyResults = 'results';
  
  // Image URLs
  static String pokemonImageUrl(int id) => 
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
      
  static String animatedGifUrl(int id) =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/$id.gif';
}
