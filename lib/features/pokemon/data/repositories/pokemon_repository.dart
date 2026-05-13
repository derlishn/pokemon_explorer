import 'package:fpdart/fpdart.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
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

  Future<Either<Failure, List<PokemonListItemModel>>> getAllPokemon({
    int limit = 20,
    int offset = 0,
  }) async {
    final String listCacheKey = '${AppConstants.keyPokemonListPrefix}$offset';

    try {
      final response = await apiClient.safeGet(
        ApiEndpoints.pokemon,
        query: {
          ApiEndpoints.limit: limit.toString(),
          ApiEndpoints.offset: offset.toString(),
        },
      );

      // Si la respuesta es exitosa, procesamos y cacheamos
      if (response.body != null && response.body is Map) {
        final List? results = response.body[ApiKeys.results];
        if (results != null) {
          final list = results
              .map(
                (e) =>
                    PokemonListItemModel.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList();

          if (SettingsService.to.useCache) {
            await storageService.write(listCacheKey, response.body);
          }
          return Right(list);
        }
      }

      throw Exception('Invalid Response Structure');
    } catch (e) {
      // FALLBACK UNIVERSAL: Si algo falla (red, servidor, parseo), forzamos caché
      if (SettingsService.to.useCache) {
        // 1. Intentar con la lista cacheada de la página específica
        final cachedData = storageService.read(listCacheKey);
        if (cachedData != null && cachedData is Map) {
          final List? results = cachedData[ApiKeys.results];
          if (results != null) {
            try {
              final list = results
                  .map(
                    (e) => PokemonListItemModel.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList();
              return Right(list);
            } catch (_) {}
          }
        }

        // 2. HARDCORE FALLBACK: Reconstruir desde los items individuales visitados (tus 21 pokemons)
        if (offset == 0) {
          final allKeys = storageService.getKeys();
          final List<PokemonListItemModel> reconstructedList = [];

          for (var key in allKeys) {
            final k = key.toString();
            // Evitamos las llaves de listas y detalles completos, buscamos solo los items básicos
            if (k.startsWith(AppConstants.pokemonCachePrefix) &&
                !k.contains('list_page_')) {
              final itemData = storageService.read(k);
              if (itemData != null && itemData is Map) {
                try {
                  reconstructedList.add(
                    PokemonListItemModel.fromJson(
                      Map<String, dynamic>.from(itemData),
                    ),
                  );
                } catch (_) {}
              }
            }
          }

          if (reconstructedList.isNotEmpty) {
            return Right(reconstructedList);
          }
        }
      }

      // Si no hay absolutamente nada en caché, devolvemos el error correspondiente
      // Si llegamos aquí es porque falló la red Y no había nada útil en local
      return const Left(ConnectionFailure(TranslationKeys.noCacheAvailable));
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
