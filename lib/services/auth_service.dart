import 'package:get/get.dart';
import 'package:pokemon_explorer/features/auth/data/repositories/auth_repository.dart';
import 'package:pokemon_explorer/core/storage/storage_service.dart';
import 'package:pokemon_explorer/core/constants/constants.dart';
import 'package:pokemon_explorer/routes/app_pages.dart';

/// Service for managing global authentication state
class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final AuthRepository authRepository;
  final StorageService storageService;

  AuthService({
    required this.authRepository,
    required this.storageService,
  });

  final isLoggedIn = false.obs;
  final userName = 'Guest'.obs;

  /// Initializes auth state from persistent storage
  Future<AuthService> init() async {
    isLoggedIn.value =
        storageService.read<bool>(AppConstants.keyIsLoggedIn) ?? false;

    final result = await authRepository.getSavedUsername();
    result.fold(
      (failure) => userName.value = 'Guest',
      (savedUser) => userName.value = savedUser ?? 'Guest',
    );

    return this;
  }

  /// Handles login logic and persists session
  Future<void> login(String user, String password) async {
    isLoggedIn.value = true;
    userName.value = user;

    // Persist session state
    await storageService.write(AppConstants.keyIsLoggedIn, true);

    // Persist credentials securely
    await authRepository.saveCredentials(user, password);

    await Get.offAllNamed(AppRoutes.home);
  }

  /// Handles logout logic and clears session
  Future<void> logout() async {
    isLoggedIn.value = false;
    userName.value = 'Guest';

    // Clear session and secure data
    await storageService.remove(AppConstants.keyIsLoggedIn);
    await authRepository.clearSession();

    await Get.offAllNamed(AppRoutes.login);
  }
}
