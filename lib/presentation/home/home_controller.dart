import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/data/repository/pokemon_repository.dart';

class HomeController extends GetxController {
  final IPokemonRepository _repository;
  
  HomeController(this._repository);

  static const int _pageSize = 20;

  final PagingController<int, PokemonListItemModel> pagingController = 
      PagingController(firstPageKey: 0);

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await _repository.getPokemonList(
        offset: pageKey, 
        limit: _pageSize,
      );
      
      final isLastPage = response.next == null;
      
      if (isLastPage) {
        pagingController.appendLastPage(response.results);
      } else {
        final nextPageKey = pageKey + response.results.length;
        pagingController.appendPage(response.results, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  void refreshData() {
    pagingController.refresh();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
