import 'package:pokemon_explorer/core/constants/api_keys.dart';

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
