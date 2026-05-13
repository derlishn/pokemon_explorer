import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/data/models/pokemon_detail_model.dart';

class PokemonRepository {
  final _connect = GetConnect();
  final _cache = GetStorage();
  static const String _cachePrefix = 'pokemon_item_';

  /// Fetches the base list as fast as possible
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

  /// Fetches detail for a single pokemon, checking cache first
  Future<PokemonDetailModel> getPokemonDetail(int id, {String? name}) async {
    // Check cache if name is provided
    if (name != null) {
      final cachedData = _cache.read(_cachePrefix + name);
      if (cachedData != null) {
        return PokemonDetailModel.fromListItem(PokemonListItemModel.fromJson(cachedData));
      }
    }

    try {
      final response = await _connect.get('https://pokeapi.co/api/v2/pokemon/$id')
          .timeout(const Duration(seconds: 10));

      if (response.status.hasError) {
        return _handleError(response);
      }

      final detail = PokemonDetailModel.fromJson(response.body);
      
      // Save basic info back to cache if name is provided
      if (name != null) {
        final item = PokemonListItemModel(
          name: name,
          url: 'https://pokeapi.co/api/v2/pokemon/$id/',
          types: detail.types.map((t) => t.name).toList(),
        );
        _cache.write(_cachePrefix + name, item.toJson());
      }

      return detail;
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
