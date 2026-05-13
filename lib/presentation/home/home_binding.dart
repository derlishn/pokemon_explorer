import 'package:get/get.dart';
import 'package:pokemon_explorer/data/repository/pokemon_repository.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(repository: Get.find<PokemonRepository>()));
  }
}
