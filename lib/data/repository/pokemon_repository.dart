import 'package:get_storage/get_storage.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/data/models/pokemon_detail_model.dart';
import 'package:pokemon_explorer/helpers/api_constants.dart';
import 'package:pokemon_explorer/data/network/api_client.dart';
import 'package:pokemon_explorer/services/settings_service.dart';

/// Repository for handling Pokemon data from API and Local Storage
class PokemonRepository {
  final ApiClient apiClient;
  final _cache = GetStorage();
  static const String _cachePrefix = 'pokemon_item_';

  PokemonRepository({required this.apiClient});

  /// Fetches the base Pokemon list from remote source
  Future<List<PokemonListItemModel>> getAllPokemon({int limit = 20, int offset = 0}) async {
    try {
      final response = await apiClient.safeGet(
        ApiConstants.pokemonEndpoint,
        query: {
          ApiConstants.paramLimit: limit.toString(),
          ApiConstants.paramOffset: offset.toString()
        },
      );

      final List results = response.body[ApiConstants.keyResults];
      return results.map((e) => PokemonListItemModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches Pokemon details, checking local cache before network call
  Future<PokemonDetailModel> getPokemonDetail(int id, {String? name}) async {
    // Return cached data if available and enabled
    if (SettingsService.to.useCache && name != null) {
      final cachedData = _cache.read(_cachePrefix + name);
      if (cachedData != null) {
        return PokemonDetailModel.fromListItem(PokemonListItemModel.fromJson(cachedData));
      }
    }

    try {
      final response = await apiClient.safeGet('${ApiConstants.pokemonEndpoint}/$id');

      final detail = PokemonDetailModel.fromJson(response.body);
      
      // Persist basic info to cache for offline availability
      if (SettingsService.to.useCache && name != null) {
        final item = PokemonListItemModel(
          name: name,
          url: '${ApiConstants.baseUrl}${ApiConstants.pokemonEndpoint}/$id/',
          types: detail.types.map((t) => t.name).toList(),
        );
        await _cache.write(_cachePrefix + name, item.toJson());
      }

      return detail;
    } catch (e) {
      rethrow;
    }
  }
}
