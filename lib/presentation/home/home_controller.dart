import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/data/repository/pokemon_repository.dart';
import 'dart:async';

class HomeController extends GetxController {
  final PokemonRepository _repository;
  
  HomeController(this._repository);

  final PagingController<int, PokemonListItemModel> pagingController = PagingController(firstPageKey: 0);
  final RxList<PokemonListItemModel> allPokemon = <PokemonListItemModel>[].obs;
  final RxList<PokemonListItemModel> filteredPokemon = <PokemonListItemModel>[].obs;
  final RxBool isSearching = false.obs;
  
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _loadAllForSearch();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await _repository.getAllPokemon(limit: 20, offset: pageKey);
      final isLastPage = newItems.length < 20;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  Future<void> _loadAllForSearch() async {
    try {
      final all = await _repository.getAllPokemon(limit: 1000, offset: 0);
      allPokemon.assignAll(all);
    } catch (e) {
      print('Error loading all pokemon for search: $e');
    }
  }

  void onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (text.isEmpty) {
        isSearching.value = false;
        filteredPokemon.clear();
      } else {
        isSearching.value = true;
        filteredPokemon.assignAll(
          allPokemon.where((p) => p.name.toLowerCase().contains(text.toLowerCase())).toList()
        );
      }
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    pagingController.dispose();
    super.onClose();
  }
}
