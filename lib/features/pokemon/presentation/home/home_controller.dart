import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';
import 'package:pokemon_explorer/features/pokemon/data/repositories/pokemon_repository.dart';
import 'package:pokemon_explorer/services/connectivity_service.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'dart:async';

class HomeController extends GetxController {
  final PokemonRepository repository;

  static const _pageSize = 20;
  final PagingController<int, PokemonListItemModel> pagingController =
      PagingController(firstPageKey: 0);

  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  bool _isDisposed = false;
  String _lastQuery = '';
  final List<PokemonListItemModel> _currentSearchResults = [];

  HomeController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });

    ever(searchQuery, (_) => _onSearchChanged());

    // Refresh when cache is cleared in settings
    ever(SettingsService.to.refreshSignalRx, (_) {
      pagingController.refresh();
    });

    // Auto-retry when connection returns
    ever(ConnectivityService.to.isConnectedRx, (bool connected) {
      if (connected && pagingController.error != null) {
        pagingController.retryLastFailedRequest();
      }
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    if (searchQuery.isNotEmpty) {
      if (_currentSearchResults.isNotEmpty || pageKey == 0) {
        final result = await repository.getAllPokemon(limit: 100, offset: 0);
        result.fold(
          (failure) {
            isSearching.value = false;
            if (!_isDisposed) pagingController.error = failure.message.tr;
          },
          (allResults) {
            final newItems = allResults
                .where(
                  (p) => p.name.toLowerCase().contains(
                    searchQuery.value.toLowerCase(),
                  ),
                )
                .toList();
            pagingController.appendLastPage(newItems);
            _fetchTypesInBackground(newItems);
            isSearching.value = false;
          },
        );
      } else {
        pagingController.appendLastPage([]);
        isSearching.value = false;
      }
    } else {
      final result = await repository.getAllPokemon(
        limit: _pageSize,
        offset: pageKey,
      );

      result.fold(
        (failure) {
          isSearching.value = false;
          if (!_isDisposed) pagingController.error = failure.message.tr;
        },
        (newItems) {
          final isLastPage = newItems.length < _pageSize;
          if (isLastPage) {
            pagingController.appendLastPage(newItems);
          } else {
            final nextPageKey = pageKey + newItems.length;
            pagingController.appendPage(newItems, nextPageKey);
          }
          _fetchTypesInBackground(newItems);
          isSearching.value = false;
        },
      );
    }
  }

  void _fetchTypesInBackground(List<PokemonListItemModel> items) async {
    int updateCount = 0;
    for (var item in items) {
      if (_isDisposed) return;
      if (item.types.isNotEmpty) continue;

      final result = await repository.getPokemonDetail(
        item.id,
        name: item.name,
      );

      result.fold(
        (failure) => null,
        (detail) {
          if (_isDisposed) return;
          final typeNames = detail.types.map((e) => e.name).toList();
          final itemList = pagingController.itemList;
          if (itemList != null) {
            final index = itemList.indexWhere((element) => element.name == item.name);
            if (index != -1) {
              itemList[index] = item.copyWith(types: typeNames);
              updateCount++;
              
              // Only rebuild UI every 4 items or at the end of the batch
              // This drastically improves performance (from 20 rebuilds to 5)
              if (updateCount % 4 == 0 || updateCount == items.length) {
                // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                pagingController.notifyListeners();
              }
            }
          }
        },
      );
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

      if (query.isNotEmpty) {
        final result = await repository.getAllPokemon(limit: 100, offset: 0);
        result.fold(
          (failure) {
            // Si falla la búsqueda (ej. offline y sin caché),
            // limpiamos la lista actual para mostrar el estado de error/vacío del PagingController
            isSearching.value = false;
            pagingController.error = failure.message.tr;
          },
          (allResults) {
            final newResults = allResults
                .where(
                  (p) => p.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

            isSearching.value = false;
            if (newResults.isEmpty) {
              pagingController.itemList = [];
              pagingController.error = TranslationKeys.noResults.tr;
            } else {
              pagingController.value = PagingState(
                itemList: newResults,
                nextPageKey: null,
                error: null,
              );
            }
          },
        );
      } else {
        pagingController.refresh();
      }
    });
  }

  set search(String query) {
    searchController.text = query;
  }

  void clearSearch() {
    searchController.clear();
  }

  @override
  void onClose() {
    _isDisposed = true;
    _debounce?.cancel();
    searchController.dispose();
    pagingController.dispose();
    super.onClose();
  }
}
