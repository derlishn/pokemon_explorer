import 'package:get/get.dart';
import 'package:pokemon_explorer/data/repository/pokemon_repository.dart';
import 'package:pokemon_explorer/data/network/api_client.dart';
import 'package:pokemon_explorer/services/auth_service.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/services/favorites_service.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Services
    await Get.putAsync(() => SettingsService().init());
    await Get.putAsync(() => AuthService().init());
    await Get.putAsync(() => FavoritesService().init());

    // Network
    Get.put(ApiClient());

    // Repositories
    Get.lazyPut(() => PokemonRepository(apiClient: Get.find()));
  }
}
