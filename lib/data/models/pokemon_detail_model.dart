import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';

class PokemonDetailModel {
  final int id;
  final String name;
  final int height;
  final int weight;
  final int baseExperience;
  final List<PokemonTypeModel> types;
  final List<PokemonStatModel> stats;
  final List<PokemonAbilityModel> abilities;

  PokemonDetailModel({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.baseExperience,
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
      baseExperience: json['base_experience'] ?? 0,
      types: (json['types'] as List)
          .map((i) => PokemonTypeModel.fromJson(i))
          .toList(),
      stats: (json['stats'] as List)
          .map((i) => PokemonStatModel.fromJson(i))
          .toList(),
      abilities: (json['abilities'] as List)
          .map((i) => PokemonAbilityModel.fromJson(i))
          .toList(),
    );
  }

  /// Helper to create a partial detail from a list item (cached types)
  factory PokemonDetailModel.fromListItem(PokemonListItemModel item) {
    return PokemonDetailModel(
      id: item.id,
      name: item.name,
      height: 0,
      weight: 0,
      baseExperience: 0,
      types: item.types.map((t) => PokemonTypeModel(name: t)).toList(),
      stats: [],
      abilities: [],
    );
  }

  String get formattedId => '#${id.toString().padLeft(3, '0')}';
  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}

class PokemonTypeModel {
  final String name;

  PokemonTypeModel({required this.name});

  factory PokemonTypeModel.fromJson(Map<String, dynamic> json) {
    return PokemonTypeModel(
      name: json['type']['name'],
    );
  }
}

class PokemonStatModel {
  final String name;
  final int value;

  PokemonStatModel({required this.name, required this.value});

  factory PokemonStatModel.fromJson(Map<String, dynamic> json) {
    return PokemonStatModel(
      name: json['stat']['name'],
      value: json['base_stat'],
    );
  }
}

class PokemonAbilityModel {
  final String name;

  PokemonAbilityModel({required this.name});

  factory PokemonAbilityModel.fromJson(Map<String, dynamic> json) {
    return PokemonAbilityModel(
      name: json['ability']['name'],
    );
  }
}
