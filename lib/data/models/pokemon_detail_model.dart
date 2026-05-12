class PokemonDetailModel {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<PokemonType> types;
  final List<PokemonStat> stats;
  final List<PokemonAbility> abilities;

  PokemonDetailModel({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.stats,
    required this.abilities,
  });

  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) {
    return PokemonDetailModel(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      types: (json['types'] as List)
          .map((i) => PokemonType.fromJson(i))
          .toList(),
      stats: (json['stats'] as List)
          .map((i) => PokemonStat.fromJson(i))
          .toList(),
      abilities: (json['abilities'] as List)
          .map((i) => PokemonAbility.fromJson(i))
          .toList(),
    );
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  // Helper to get formatted ID like #001
  String get formattedId => '#${id.toString().padLeft(3, '0')}';
}

class PokemonType {
  final String name;
  PokemonType({required this.name});
  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(name: json['type']['name']);
  }
}

class PokemonStat {
  final String name;
  final int value;
  PokemonStat({required this.name, required this.value});
  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      name: json['stat']['name'],
      value: json['base_stat'],
    );
  }
}

class PokemonAbility {
  final String name;
  PokemonAbility({required this.name});
  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(name: json['ability']['name']);
  }
}
