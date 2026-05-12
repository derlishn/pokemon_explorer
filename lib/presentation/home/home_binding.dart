import 'package:get/get.dart';
import 'package:pokemon_explorer/data/repository/pokemon_repository.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Injecting implementation of the repository
    Get.lazyPut<IPokemonRepository>(() => PokemonRepositoryImpl());
    
    // Injecting controller with the repository abstraction
    Get.lazyPut<HomeController>(() => HomeController(Get.find<IPokemonRepository>()));
  }
}
