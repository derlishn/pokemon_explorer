import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pokemon_explorer/routes/app_pages.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final _box = GetStorage();
  final _isLoggedIn = false.obs;
  final userName = ''.obs;

  bool get isLoggedIn => _isLoggedIn.value;

  Future<AuthService> init() async {
    _isLoggedIn.value = _box.read('is_logged_in') ?? false;
    userName.value = _box.read('user_name') ?? 'Entrenador';
    return this;
  }

  void login(String user, String password) {
    if (user == 'flutter' && password == 'flutter') {
      _isLoggedIn.value = true;
      userName.value = user;
      _box.write('is_logged_in', true);
      _box.write('user_name', user);
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.snackbar(
        'login'.tr,
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
