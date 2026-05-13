import 'package:fpdart/fpdart.dart';
import 'package:pokemon_explorer/core/error/failure.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';
import 'package:pokemon_explorer/core/config/api_config.dart';
import 'package:pokemon_explorer/core/constants/api_endpoints.dart';
import 'package:pokemon_explorer/core/constants/api_keys.dart';
import 'package:pokemon_explorer/core/constants/constants.dart';
import 'package:pokemon_explorer/core/network/api_client.dart';
import 'package:pokemon_explorer/core/network/network_exceptions.dart';
import 'package:pokemon_explorer/core/storage/storage_service.dart';
import 'package:pokemon_explorer/services/settings_service.dart';

/// Repository for handling Pokemon data with functional error handling
class PokemonRepository {
  final ApiClient apiClient;
  final StorageService storageService;

  PokemonRepository({required this.apiClient, required this.storageService});

  /// Fetches the base Pokemon list from remote source
  Future<Either<Failure, List<PokemonListItemModel>>> getAllPokemon({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await apiClient.safeGet(
        ApiEndpoints.pokemon,
        query: {
          ApiEndpoints.limit: limit.toString(),
          ApiEndpoints.offset: offset.toString(),
        },
      );

      final List results = response.body[ApiKeys.results];
      final list = results
          .map((e) => PokemonListItemModel.fromJson(e))
          .toList();
      return Right(list);
    } on NoInternetException catch (e) {
      return Left(ConnectionFailure(e.errorCode));
    } on NetworkException catch (e) {
      return Left(ServerFailure(e.errorCode, e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  /// Fetches Pokemon details, checking local storage before network call
  Future<Either<Failure, PokemonDetailModel>> getPokemonDetail(
    int id, {
    String? name,
  }) async {
    final String basicCacheKey = '${AppConstants.pokemonCachePrefix}$name';
    final String fullCacheKey = '${AppConstants.pokemonDetailCachePrefix}$id';

    // 1. Try to return FULL cached detail first
    if (SettingsService.to.useCache) {
      final cachedFull = storageService.read(fullCacheKey);
      if (cachedFull != null) {
        return Right(PokemonDetailModel.fromJson(cachedFull));
      }
    }

    try {
      // 2. Fetch from network if full detail not in cache
      final response = await apiClient.safeGet('${ApiEndpoints.pokemon}/$id');
      final detail = PokemonDetailModel.fromJson(response.body);

      // 3. Persist both basic and full info
      if (SettingsService.to.useCache) {
        // Cache full detail
        await storageService.write(fullCacheKey, response.body);
        
        // Cache/Update basic info for list performance
        if (name != null) {
          final item = PokemonListItemModel(
            name: name,
            url: '${ApiConfig.baseUrl}${ApiEndpoints.pokemon}/$id/',
            types: detail.types.map((t) => t.name).toList(),
          );
          await storageService.write(basicCacheKey, item.toJson());
        }
      }

      return Right(detail);
    } on NoInternetException catch (e) {
      return Left(ConnectionFailure(e.errorCode));
    } on NetworkException catch (e) {
      return Left(ServerFailure(e.errorCode, e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
