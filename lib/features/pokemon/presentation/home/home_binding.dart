import 'package:get/get.dart';
import 'package:pokemon_explorer/features/pokemon/data/repositories/pokemon_repository.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(repository: Get.find<PokemonRepository>()));
  }
}
