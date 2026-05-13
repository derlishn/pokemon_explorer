import 'package:get/get.dart';
import 'package:pokemon_explorer/presentation/favorites/favorites_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritesController>(() => FavoritesController());
  }
}
