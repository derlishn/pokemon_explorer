import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/data/repository/pokemon_repository.dart';

class HomeController extends GetxController {
  final IPokemonRepository _repository;
  
  HomeController(this._repository);

  static const int _pageSize = 20;

  final PagingController<int, PokemonListItemModel> pagingController = 
      PagingController(
        firstPageKey: 0,
        invisibleItemsThreshold: 3,
      );

  // Search related
  final allPokemon = <PokemonListItemModel>[].obs;
  final filteredPokemon = <PokemonListItemModel>[].obs;
  final isSearching = false.obs;
  final searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAllPokemon(); // Load for search
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  // Load all pokemon names once for instant local search
  Future<void> _loadAllPokemon() async {
    try {
      final response = await _repository.getPokemonList(offset: 0, limit: 2000);
      allPokemon.assignAll(response.results);
    } catch (e) {
      print('Error loading search data: $e');
    }
  }

  void onSearchChanged(String text) {
    searchText.value = text;
    if (text.isEmpty) {
      isSearching.value = false;
      filteredPokemon.clear();
    } else {
      isSearching.value = true;
      filteredPokemon.assignAll(
        allPokemon.where((p) => 
          p.name.toLowerCase().contains(text.toLowerCase()) || 
          p.id.toString().contains(text)
        ).toList(),
      );
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await _repository.getPokemonList(
        offset: pageKey, 
        limit: _pageSize,
      );
      
      // ESCUDO DE SEGURIDAD: 
      // Si el controlador se cerró durante la petición de red, cancelamos la actualización.
      if (isClosed) return;

      final isLastPage = response.next == null;
      
      if (isLastPage) {
        pagingController.appendLastPage(response.results);
      } else {
        final nextPageKey = pageKey + response.results.length;
        pagingController.appendPage(response.results, nextPageKey);
      }
    } catch (error) {
      // Verificamos de nuevo antes de reportar un error
      if (!isClosed) {
        pagingController.error = error;
      }
    }
  }

  void refreshData() {
    pagingController.refresh();
  }

  @override
  void onClose() {
    // Primero marcamos como cerrado y luego liberamos la memoria
    pagingController.dispose();
    super.onClose();
  }
}
