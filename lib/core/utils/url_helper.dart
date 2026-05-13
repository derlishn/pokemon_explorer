/// Helper class to centralize URL generation logic
class UrlHelper {
  static const String _spritesBase = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon';

  /// Generates the official artwork URL for a given Pokemon ID
  static String getOfficialArtwork(int id) => 
      '$_spritesBase/other/official-artwork/$id.png';

  /// Generates an animated GIF URL (Gen V style) for a given Pokemon ID
  static String getAnimatedGif(int id) =>
      '$_spritesBase/versions/generation-v/black-white/animated/$id.gif';
}
