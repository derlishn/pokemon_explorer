import 'package:get/get.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/data/repository/pokemon_repository.dart';

class HomeController extends GetxController with StateMixin<List<PokemonListItemModel>> {
  final IPokemonRepository _repository;
  
  HomeController(this._repository);

  final RxList<PokemonListItemModel> pokemonList = <PokemonListItemModel>[].obs;
  int _currentOffset = 0;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchPokemon();
  }

  Future<void> fetchPokemon() async {
    if (_currentOffset == 0) change(null, status: RxStatus.loading());

    try {
      final response = await _repository.getPokemonList(offset: _currentOffset);
      
      if (response.results.isEmpty && _currentOffset == 0) {
        change([], status: RxStatus.empty());
      } else {
        pokemonList.addAll(response.results);
        _currentOffset += response.results.length;
        _hasMore = response.next != null;
        change(pokemonList, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (_hasMore) {
      await fetchPokemon();
    }
  }
}
