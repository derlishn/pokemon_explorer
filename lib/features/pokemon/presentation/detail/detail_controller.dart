import 'package:get/get.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';
import 'package:pokemon_explorer/features/pokemon/data/repositories/pokemon_repository.dart';
import 'package:pokemon_explorer/core/utils/hero_tags.dart';
import 'package:pokemon_explorer/core/constants/constants.dart';

class DetailController extends GetxController with StateMixin<PokemonDetailModel> {
  final PokemonRepository _repository;
  
  DetailController(this._repository);

  late PokemonListItemModel initialData;
  late String heroTag;

  @override
  void onInit() {
    super.onInit();
    
    // Support both direct object (backward compatibility) and Map (new unique tags)
    if (Get.arguments is Map) {
      initialData = Get.arguments[AppConstants.argPokemon] as PokemonListItemModel;
      heroTag = Get.arguments[AppConstants.argHeroTag] as String;
    } else {
      initialData = Get.arguments as PokemonListItemModel;
      // Use utility to generate fallback tag
      heroTag = HeroTags.getDefaultTag(initialData.id);
    }
    
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    change(null, status: RxStatus.loading());
    final result = await _repository.getPokemonDetail(
      initialData.id, 
      name: initialData.name,
    );
    
    result.fold(
      (failure) => change(null, status: RxStatus.error(failure.message.tr)),
      (detail) => change(detail, status: RxStatus.success()),
    );
  }
}
