import 'package:pokemon_explorer/helpers/api_constants.dart';

class PokemonListItemModel {
  final String name;
  final String url;
  final List<String> types;

  PokemonListItemModel({
    required this.name,
    required this.url,
    this.types = const [],
  });

  factory PokemonListItemModel.fromJson(Map<String, dynamic> json) {
    return PokemonListItemModel(
      name: json[ApiConstants.keyName],
      url: json[ApiConstants.keyUrl],
      types: json[ApiConstants.keyTypes] != null 
          ? List<String>.from(json[ApiConstants.keyTypes]) 
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiConstants.keyName: name,
      ApiConstants.keyUrl: url,
      ApiConstants.keyTypes: types,
    };
  }

  int get id {
    final parts = url.split('/');
    return int.parse(parts[parts.length - 2]);
  }

  String get imageUrl => ApiConstants.pokemonImageUrl(id);

  PokemonListItemModel copyWith({List<String>? types}) {
    return PokemonListItemModel(
      name: name,
      url: url,
      types: types ?? this.types,
    );
  }
}
