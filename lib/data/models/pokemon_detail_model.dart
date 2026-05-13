import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/core/constants/api_keys.dart';
import 'package:pokemon_explorer/core/utils/url_helper.dart';

/// Represents the full data of a Pokemon including stats and abilities
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

  /// Factory constructor for detailed data from API
  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) {
    return PokemonDetailModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      height: json[ApiKeys.height],
      weight: json[ApiKeys.weight],
      baseExperience: json[ApiKeys.baseExperience] ?? 0,
      types: (json[ApiKeys.types] as List)
          .map((i) => PokemonTypeModel.fromJson(i))
          .toList(),
      stats: (json[ApiKeys.stats] as List)
          .map((i) => PokemonStatModel.fromJson(i))
          .toList(),
      abilities: (json[ApiKeys.abilities] as List)
          .map((i) => PokemonAbilityModel.fromJson(i))
          .toList(),
    );
  }

  /// Helper to create a placeholder detail model from a list item
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
  String get imageUrl => UrlHelper.getOfficialArtwork(id);
}

/// Simplified type model for nested JSON parsing
class PokemonTypeModel {
  final String name;

  PokemonTypeModel({required this.name});

  factory PokemonTypeModel.fromJson(Map<String, dynamic> json) {
    return PokemonTypeModel(
      name: json[ApiKeys.type][ApiKeys.name],
    );
  }
}

/// Simplified stat model for nested JSON parsing
class PokemonStatModel {
  final String name;
  final int value;

  PokemonStatModel({required this.name, required this.value});

  factory PokemonStatModel.fromJson(Map<String, dynamic> json) {
    return PokemonStatModel(
      name: json[ApiKeys.stat][ApiKeys.name],
      value: json[ApiKeys.baseStat],
    );
  }
}

/// Simplified ability model for nested JSON parsing
class PokemonAbilityModel {
  final String name;

  PokemonAbilityModel({required this.name});

  factory PokemonAbilityModel.fromJson(Map<String, dynamic> json) {
    return PokemonAbilityModel(
      name: json[ApiKeys.ability][ApiKeys.name],
    );
  }
}
