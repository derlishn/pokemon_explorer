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
  final RxBool isSearching = false.obs;
  Timer? _debounce;
  bool _isDisposed = false;
  String _lastQuery = '';
  List<PokemonListItemModel> _currentSearchResults = [];

  HomeController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    
    ever(searchQuery, (_) => _onSearchChanged());
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      List<PokemonListItemModel> newItems;
      
      if (searchQuery.isNotEmpty) {
        // Use the pre-filtered results from _onSearchChanged if available
        if (_currentSearchResults.isNotEmpty || pageKey == 0) {
          final allResults = await repository.getAllPokemon(limit: 100, offset: 0);
          newItems = allResults.where((p) => 
            p.name.toLowerCase().contains(searchQuery.value.toLowerCase())
          ).toList();
        } else {
          newItems = [];
        }
        
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

      _fetchTypesInBackground(newItems);
      isSearching.value = false;
      
    } catch (error) {
      isSearching.value = false;
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
        // Silent fail
      }
    }
  }

  void _onSearchChanged() {
    final query = searchQuery.value.trim();
    if (query == _lastQuery) return;
    _lastQuery = query;

    isSearching.value = true;

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () async {
      if (_isDisposed) return;

      // PRO LOGIC: Perform the search check BEFORE refreshing the UI
      if (query.isNotEmpty) {
        final allResults = await repository.getAllPokemon(limit: 100, offset: 0);
        final newResults = allResults.where((p) => 
          p.name.toLowerCase().contains(query.toLowerCase())
        ).toList();

        // If the new results are empty AND the current UI is already showing empty,
        // we DON'T refresh, thus preventing the flicker.
        final currentItems = pagingController.itemList ?? [];
        if (newResults.isEmpty && currentItems.isEmpty) {
          isSearching.value = false;
          return; 
        }
      }

      pagingController.refresh();
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
