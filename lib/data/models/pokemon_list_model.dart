class PokemonListItemModel {
  final String name;
  final String url;

  PokemonListItemModel({
    required this.name,
    required this.url,
  });

  factory PokemonListItemModel.fromJson(Map<String, dynamic> json) {
    return PokemonListItemModel(
      name: json['name'],
      url: json['url'],
    );
  }

  // Extract ID from URL to get the high-res image
  String get id {
    final parts = url.split('/');
    return parts[parts.length - 2];
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}

class PokemonListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<PokemonListItemModel> results;

  PokemonListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) {
    return PokemonListResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((i) => PokemonListItemModel.fromJson(i))
          .toList(),
    );
  }
}
