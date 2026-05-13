import 'package:get/get.dart';
import 'package:pokemon_explorer/services/favorites_service.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';

class FavoritesController extends GetxController {
  static FavoritesController get to => Get.find();
  
  RxList<PokemonListItemModel> get favorites => FavoritesService.to.favorites;

  void removeFavorite(PokemonListItemModel pokemon) {
    FavoritesService.to.toggleFavorite(pokemon);
  }
}
