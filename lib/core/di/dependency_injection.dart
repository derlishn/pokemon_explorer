import 'package:get/get.dart';
import 'package:pokemon_explorer/data/repository/pokemon_repository.dart';
import 'package:pokemon_explorer/data/repository/auth_repository.dart';
import 'package:pokemon_explorer/core/network/api_client.dart';
import 'package:pokemon_explorer/core/storage/storage_service.dart';
import 'package:pokemon_explorer/core/storage/secure_storage_service.dart';
import 'package:pokemon_explorer/services/auth_service.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/services/favorites_service.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Services
    final storage = StorageService();
    final secureStorage = SecureStorageService();
    
    await Get.putAsync(() => SettingsService().init());
    Get.put(storage);
    Get.put(secureStorage);
    
    // Repositories
    final authRepo = AuthRepository(secureStorage: secureStorage);
    Get.put(authRepo);
    
    await Get.putAsync(() => AuthService(
      authRepository: authRepo,
      storageService: storage,
    ).init());
    
    await Get.putAsync(() => FavoritesService().init());

    // Network
    Get.put(ApiClient());

    // Repositories
    Get.lazyPut(() => PokemonRepository(
      apiClient: Get.find(),
      storageService: storage,
    ));
  }
}
