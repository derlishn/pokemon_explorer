import 'package:pokemon_explorer/core/constants/api_keys.dart';

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
