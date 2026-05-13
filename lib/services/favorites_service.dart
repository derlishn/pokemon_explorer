import 'package:get/get.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';
import 'package:pokemon_explorer/core/storage/storage_service.dart';
import 'package:pokemon_explorer/core/constants/constants.dart';

class FavoritesService extends GetxService {
  static FavoritesService get to => Get.find();
  
  final StorageService storageService;
  
  FavoritesService({required this.storageService});
  
  // Reactive list of full Pokemon objects
  final favorites = <PokemonListItemModel>[].obs;

  Future<FavoritesService> init() async {
    // Load saved favorites from storage using central StorageService
    final List<dynamic>? savedData = storageService.read<List<dynamic>>(AppConstants.keyFavorites);
    
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
    
    // Persist to storage using central StorageService
    storageService.write(
      AppConstants.keyFavorites, 
      favorites.map((p) => p.toJson()).toList(),
    );
  }

  bool isFavorite(int pokemonId) {
    return favorites.any((p) => p.id == pokemonId);
  }

  void clearAll() {
    favorites.clear();
    storageService.remove(AppConstants.keyFavorites);
  }
}
