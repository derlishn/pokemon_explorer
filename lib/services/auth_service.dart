import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pokemon_explorer/helpers/constants.dart';
import 'package:pokemon_explorer/routes/app_pages.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final _box = GetStorage();
  final _isLoggedIn = false.obs;

  bool get isLoggedIn => _isLoggedIn.value;

  Future<AuthService> init() async {
    _isLoggedIn.value =
        _box.read(AppConstants.keyIsDarkMode) ??
        false; // Using a generic key for now or creating a new one
    // Let's use a specific key for auth
    _isLoggedIn.value = _box.read('is_logged_in') ?? false;
    return this;
  }

  void login(String user, String password) {
    if (user == 'flutter' && password == 'flutter') {
      _isLoggedIn.value = true;
      _box.write('is_logged_in', true);
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.snackbar(
        'error_network'.tr, // Reusing key for simplicity or adding new one
        'invalid_credentials'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void logout() {
    _isLoggedIn.value = false;
    _box.write('is_logged_in', false);
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
