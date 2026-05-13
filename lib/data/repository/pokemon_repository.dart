import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/data/models/pokemon_detail_model.dart';
import 'package:pokemon_explorer/helpers/api_constants.dart';
import 'package:pokemon_explorer/helpers/constants.dart';
import 'package:pokemon_explorer/data/network/api_client.dart';
import 'package:pokemon_explorer/data/services/storage_service.dart';
import 'package:pokemon_explorer/services/settings_service.dart';

/// Repository for handling Pokemon data with clean separation of concerns
class PokemonRepository {
  final ApiClient apiClient;
  final StorageService storageService;

  PokemonRepository({
    required this.apiClient,
    required this.storageService,
  });

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

  /// Fetches Pokemon details, checking local storage before network call
  Future<PokemonDetailModel> getPokemonDetail(int id, {String? name}) async {
    final String cacheKey = '${AppConstants.keyPokemonCachePrefix}$name';

    // Return cached data if available and enabled
    if (SettingsService.to.useCache && name != null) {
      final cachedData = storageService.read(cacheKey);
      if (cachedData != null) {
        return PokemonDetailModel.fromListItem(PokemonListItemModel.fromJson(cachedData));
      }
    }

    try {
      final response = await apiClient.safeGet('${ApiConstants.pokemonEndpoint}/$id');

      final detail = PokemonDetailModel.fromJson(response.body);
      
      // Persist basic info to local storage for offline availability
      if (SettingsService.to.useCache && name != null) {
        final item = PokemonListItemModel(
          name: name,
          url: '${ApiConstants.baseUrl}${ApiConstants.pokemonEndpoint}/$id/',
          types: detail.types.map((t) => t.name).toList(),
        );
        await storageService.write(cacheKey, item.toJson());
      }

      return detail;
    } catch (e) {
      rethrow;
    }
  }
}
