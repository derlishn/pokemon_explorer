import 'package:get/get.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/data/models/pokemon_detail_model.dart';

class PokemonRepository {
  final _connect = GetConnect();

  Future<List<PokemonListItemModel>> getAllPokemon({int limit = 20, int offset = 0}) async {
    try {
      final response = await _connect.get(
        'https://pokeapi.co/api/v2/pokemon',
        query: {'limit': limit.toString(), 'offset': offset.toString()},
      ).timeout(const Duration(seconds: 10));

      if (response.status.hasError) {
        return _handleError(response);
      }

      final List results = response.body['results'];
      return results.map((e) => PokemonListItemModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('error_network'.tr);
    }
  }

  Future<PokemonDetailModel> getPokemonDetail(int id) async {
    try {
      final response = await _connect.get('https://pokeapi.co/api/v2/pokemon/$id')
          .timeout(const Duration(seconds: 10));

      if (response.status.hasError) {
        return _handleError(response);
      }

      return PokemonDetailModel.fromJson(response.body);
    } catch (e) {
      throw Exception('error_network'.tr);
    }
  }

  dynamic _handleError(Response response) {
    if (response.status.isNotFound) {
      throw Exception('pokemon_not_found'.tr);
    } else if (response.status.connectionError) {
      throw Exception('error_network'.tr);
    } else if (response.status.isServerError) {
      throw Exception('error_server'.tr);
    } else {
      throw Exception('error_unknown'.tr);
    }
  }
}
