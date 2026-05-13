import 'package:get/get.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/data/models/pokemon_detail_model.dart';

class PokemonRepository {
  final _connect = GetConnect();

  Future<List<PokemonListItemModel>> getAllPokemon({int limit = 151, int offset = 0}) async {
    final response = await _connect.get(
      'https://pokeapi.co/api/v2/pokemon',
      query: {'limit': limit.toString(), 'offset': offset.toString()},
    );

    if (response.status.hasError) {
      throw Exception('error_network'.tr);
    }

    final List results = response.body['results'];
    return results.map((e) => PokemonListItemModel.fromJson(e)).toList();
  }

  Future<PokemonDetailModel> getPokemonDetail(int id) async {
    final response = await _connect.get('https://pokeapi.co/api/v2/pokemon/$id');

    if (response.status.hasError) {
      throw Exception('error_network'.tr);
    }

    return PokemonDetailModel.fromJson(response.body);
  }
}
