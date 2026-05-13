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
      name: json['name'],
      url: json['url'],
      types: json['types'] != null ? List<String>.from(json['types']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'types': types,
    };
  }

  int get id {
    final parts = url.split('/');
    return int.parse(parts[parts.length - 2]);
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  PokemonListItemModel copyWith({List<String>? types}) {
    return PokemonListItemModel(
      name: name,
      url: url,
      types: types ?? this.types,
    );
  }
}
