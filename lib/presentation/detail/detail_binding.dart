import 'package:get/get.dart';
import 'package:pokemon_explorer/data/repository/pokemon_repository.dart';
import 'detail_controller.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailController>(
      () => DetailController(Get.find<IPokemonRepository>()),
    );
  }
}
