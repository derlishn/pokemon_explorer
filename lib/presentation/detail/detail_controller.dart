import 'package:get/get.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/data/models/pokemon_detail_model.dart';
import 'package:pokemon_explorer/data/repository/pokemon_repository.dart';

class DetailController extends GetxController with StateMixin<PokemonDetailModel> {
  final PokemonRepository _repository;
  
  DetailController(this._repository);

  late PokemonListItemModel initialData;

  @override
  void onInit() {
    super.onInit();
    initialData = Get.arguments as PokemonListItemModel;
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    change(null, status: RxStatus.loading());
    try {
      final detail = await _repository.getPokemonDetail(initialData.id);
      change(detail, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
