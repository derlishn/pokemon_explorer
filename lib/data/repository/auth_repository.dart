import 'package:pokemon_explorer/core/storage/secure_storage_service.dart';
import 'package:pokemon_explorer/core/constants/constants.dart';

/// Repository for handling authentication logic and secure credential storage
class AuthRepository {
  final SecureStorageService secureStorage;

  AuthRepository({required this.secureStorage});

  /// Saves user credentials securely
  Future<void> saveCredentials(String username, String password) async {
    await secureStorage.write(AppConstants.keyUserName, username);
    await secureStorage.write(AppConstants.keyPassword, password);
  }

  /// Retrieves saved username
  Future<String?> getSavedUsername() {
    return secureStorage.read(AppConstants.keyUserName);
  }

  /// Retrieves saved password
  Future<String?> getSavedPassword() {
    return secureStorage.read(AppConstants.keyPassword);
  }

  /// Clears all session data
  Future<void> clearSession() async {
    await secureStorage.deleteAll();
  }
}
