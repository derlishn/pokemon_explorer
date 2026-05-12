import 'package:pokemon_explorer/data/models/pokemon_detail_model.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/helpers/constants.dart';
import 'package:pokemon_explorer/services/global_service.dart';
import 'package:get/get.dart';

abstract class IPokemonRepository {
  Future<PokemonListResponse> getPokemonList({int offset = 0, int limit = 20});
  Future<PokemonDetailModel> getPokemonDetail(String idOrName);
}

class PokemonRepositoryImpl implements IPokemonRepository {
  final GlobalService _api = Get.find<GlobalService>();

  @override
  Future<PokemonListResponse> getPokemonList({int offset = 0, int limit = 20}) async {
    final response = await _api.get(Endpoints.pokemon, queryParams: {
      'offset': offset.toString(),
      'limit': limit.toString(),
    });
    
    return PokemonListResponse.fromJson(response);
  }

  @override
  Future<PokemonDetailModel> getPokemonDetail(String idOrName) async {
    final response = await _api.get('${Endpoints.pokemon}/$idOrName');
    return PokemonDetailModel.fromJson(response);
  }
}
