import 'package:pokemon_explorer/core/constants/api_keys.dart';
import 'package:pokemon_explorer/core/utils/url_helper.dart';

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
      name: json[ApiKeys.name],
      url: json[ApiKeys.url],
      types: json[ApiKeys.types] != null 
          ? List<String>.from(json[ApiKeys.types]) 
          : [],
    );
  }

  /// Converts the model back to JSON for local persistence
  Map<String, dynamic> toJson() {
    return {
      ApiKeys.name: name,
      ApiKeys.url: url,
      ApiKeys.types: types,
    };
  }

  /// Extracts the Pokemon ID from the detail URL
  int get id {
    final parts = url.split('/');
    // The URL ends with /id/, so the ID is at length - 2
    return int.parse(parts[parts.length - 2]);
  }

  /// Get the official artwork URL based on ID
  String get imageUrl => UrlHelper.getOfficialArtwork(id);

  PokemonListItemModel copyWith({List<String>? types}) {
    return PokemonListItemModel(
      name: name,
      url: url,
      types: types ?? this.types,
    );
  }
}
