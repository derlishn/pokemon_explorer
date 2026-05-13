import 'package:pokemon_explorer/helpers/api_constants.dart';

/// Represents a basic Pokemon item used in lists and pagination
class PokemonListItemModel {
  final String name;
  final String url;
  final List<String> types;

  PokemonListItemModel({
    required this.name,
    required this.url,
    this.types = const [],
  });

  /// Factory constructor for creating a model from API JSON response
  factory PokemonListItemModel.fromJson(Map<String, dynamic> json) {
    return PokemonListItemModel(
      name: json[ApiConstants.keyName],
      url: json[ApiConstants.keyUrl],
      types: json[ApiConstants.keyTypes] != null 
          ? List<String>.from(json[ApiConstants.keyTypes]) 
          : [],
    );
  }

  /// Converts the model back to JSON for local persistence
  Map<String, dynamic> toJson() {
    return {
      ApiConstants.keyName: name,
      ApiConstants.keyUrl: url,
      ApiConstants.keyTypes: types,
    };
  }

  /// Extracts the Pokemon ID from the detail URL
  int get id {
    final parts = url.split('/');
    return int.parse(parts[parts.length - 2]);
  }

  /// Get the official artwork URL based on ID
  String get imageUrl => ApiConstants.pokemonImageUrl(id);

  PokemonListItemModel copyWith({List<String>? types}) {
    return PokemonListItemModel(
      name: name,
      url: url,
      types: types ?? this.types,
    );
  }
}
