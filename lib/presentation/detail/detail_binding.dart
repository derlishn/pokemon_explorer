import 'package:get/get.dart';
import 'package:pokemon_explorer/data/repository/pokemon_repository.dart';
import 'package:pokemon_explorer/presentation/detail/detail_controller.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailController(Get.find<PokemonRepository>()));
  }
}
