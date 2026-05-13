import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/data/repository/pokemon_repository.dart';
import 'dart:async';

class HomeController extends GetxController {
  final PokemonRepository repository;
  
  static const _pageSize = 20;
  final PagingController<int, PokemonListItemModel> pagingController = 
      PagingController(firstPageKey: 0);

  final RxString searchQuery = ''.obs;
  Timer? _debounce;
  bool _isDisposed = false;

  HomeController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    
    // Listen to search changes to refresh the list
    ever(searchQuery, (_) => _onSearchChanged());
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final List<PokemonListItemModel> newItems;
      
      if (searchQuery.isNotEmpty) {
        // Simple search logic for the technical test
        final allResults = await repository.getAllPokemon(limit: 100, offset: 0);
        newItems = allResults.where((p) => 
          p.name.toLowerCase().contains(searchQuery.value.toLowerCase())
        ).toList();
        
        pagingController.appendLastPage(newItems);
      } else {
        newItems = await repository.getAllPokemon(
          limit: _pageSize,
          offset: pageKey,
        );

        final isLastPage = newItems.length < _pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + newItems.length;
          pagingController.appendPage(newItems, nextPageKey);
        }
      }

      // Background loading for types (Lazy Loading)
      _fetchTypesInBackground(newItems);
      
    } catch (error) {
      if (!_isDisposed) pagingController.error = error;
    }
  }

  void _fetchTypesInBackground(List<PokemonListItemModel> items) async {
    for (var item in items) {
      if (_isDisposed) return;
      if (item.types.isNotEmpty) continue;

      try {
        final detail = await repository.getPokemonDetail(item.id, name: item.name);
        final typeNames = detail.types.map((e) => e.name).toList();
        
        if (_isDisposed) return;

        final itemList = pagingController.itemList;
        if (itemList != null) {
          final index = itemList.indexWhere((element) => element.name == item.name);
          if (index != -1) {
            itemList[index] = item.copyWith(types: typeNames);
            // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
            pagingController.notifyListeners();
          }
        }
      } catch (e) {
        // Silent fail for background tasks
      }
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!_isDisposed) pagingController.refresh();
    });
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  @override
  void onClose() {
    _isDisposed = true;
    _debounce?.cancel();
    pagingController.dispose();
    super.onClose();
  }
}
