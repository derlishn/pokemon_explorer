import 'package:pokemon_explorer/core/constants/api_keys.dart';

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
