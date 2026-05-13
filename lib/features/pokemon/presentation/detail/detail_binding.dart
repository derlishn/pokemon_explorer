import 'package:get/get.dart';
import 'package:pokemon_explorer/features/pokemon/data/repositories/pokemon_repository.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/detail/detail_controller.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailController(Get.find<PokemonRepository>()));
  }
}
