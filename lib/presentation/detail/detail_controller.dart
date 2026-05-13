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
    final result = await _repository.getPokemonDetail(initialData.id);
    
    result.fold(
      (failure) => change(null, status: RxStatus.error(failure.message.tr)),
      (detail) => change(detail, status: RxStatus.success()),
    );
  }
}
