class AvatarOption {
  final String name;
  final String id;

  const AvatarOption({required this.name, required this.id});

  String get staticUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  
  String get animatedUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/$id.gif';
}

class AvatarConfig {
  static const List<AvatarOption> availableAvatars = [
    AvatarOption(name: 'Pikachu', id: '25'),
    AvatarOption(name: 'Bulbasaur', id: '1'),
    AvatarOption(name: 'Charmander', id: '4'),
    AvatarOption(name: 'Squirtle', id: '7'),
    AvatarOption(name: 'Eevee', id: '133'),
    AvatarOption(name: 'Gengar', id: '94'),
    AvatarOption(name: 'Mewtwo', id: '150'),
    AvatarOption(name: 'Snorlax', id: '143'),
  ];
}
