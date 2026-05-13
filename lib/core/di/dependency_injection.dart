import 'package:get/get.dart';
import 'package:pokemon_explorer/features/pokemon/data/repositories/pokemon_repository.dart';
import 'package:pokemon_explorer/features/auth/data/repositories/auth_repository.dart';
import 'package:pokemon_explorer/core/network/api_client.dart';
import 'package:pokemon_explorer/core/storage/storage_service.dart';
import 'package:pokemon_explorer/core/storage/secure_storage_service.dart';
import 'package:pokemon_explorer/services/auth_service.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/services/favorites_service.dart';

class DependencyInjection {
  static Future<void> init() async {
    // 1. Foundation Infrastructure (Immediate)
    final storage = StorageService();
    final secureStorage = SecureStorageService();
    
    Get.put(storage);
    Get.put(secureStorage);
    
    // 2. Global Settings (Critical for UI Theme/Locale)
    await Get.putAsync(() => SettingsService(storageService: storage).init());
    
    // 3. Repositories (Data Access)
    final authRepo = AuthRepository(secureStorage: secureStorage);
    Get.put(authRepo);
    
    Get.put(ApiClient());
    
    Get.lazyPut(() => PokemonRepository(
      apiClient: Get.find(),
      storageService: storage,
    ));
    
    // 4. State Management Services (Business Logic)
    await Get.putAsync(() => AuthService(
      authRepository: authRepo,
      storageService: storage,
    ).init());
    
    await Get.putAsync(() => FavoritesService(storageService: storage).init());
  }
}
