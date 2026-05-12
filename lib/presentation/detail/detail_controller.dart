import 'package:get/get.dart';
import 'package:pokemon_explorer/data/models/pokemon_detail_model.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/data/repository/pokemon_repository.dart';

class DetailController extends GetxController with StateMixin<PokemonDetailModel> {
  final IPokemonRepository _repository;
  
  DetailController(this._repository);

  // Initial data from Home to show image/name immediately
  late final PokemonListItemModel initialData;

  @override
  void onInit() {
    super.onInit();
    initialData = Get.arguments as PokemonListItemModel;
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    change(null, status: RxStatus.loading());
    try {
      final detail = await _repository.getPokemonDetail(initialData.name);
      change(detail, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
