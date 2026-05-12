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
