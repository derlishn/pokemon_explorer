import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';

class FavoritesService extends GetxService {
  static FavoritesService get to => Get.find();
  
  final _storage = GetStorage();
  final _key = 'favorites_objects_list';
  
  // Reactive list of full Pokemon objects
  final favorites = <PokemonListItemModel>[].obs;

  Future<FavoritesService> init() async {
    // Load saved favorites from storage
    final List<dynamic>? savedData = _storage.read<List<dynamic>>(_key);
    if (savedData != null) {
      favorites.assignAll(
        savedData.map((e) => PokemonListItemModel.fromJson(e)).toList()
      );
    }
    return this;
  }

  void toggleFavorite(PokemonListItemModel pokemon) {
    final index = favorites.indexWhere((p) => p.id == pokemon.id);
    if (index != -1) {
      favorites.removeAt(index);
    } else {
      favorites.add(pokemon);
    }
    // Persist to storage (converting objects to JSON)
    _storage.write(_key, favorites.map((p) => p.toJson()).toList());
  }

  bool isFavorite(int pokemonId) {
    return favorites.any((p) => p.id == pokemonId);
  }
}
