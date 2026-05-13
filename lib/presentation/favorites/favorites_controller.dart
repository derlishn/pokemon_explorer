import 'package:get/get.dart';
import 'package:pokemon_explorer/services/favorites_service.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';

class FavoritesController extends GetxController {
  static FavoritesController get to => Get.find();
  
  RxList<PokemonListItemModel> get favorites => FavoritesService.to.favorites;

  void removeFavorite(PokemonListItemModel pokemon) {
    FavoritesService.to.toggleFavorite(pokemon);
  }
}
