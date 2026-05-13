import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pokemon_explorer/helpers/constants.dart';
import 'package:pokemon_explorer/routes/app_pages.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();
  
  final _box = GetStorage();
  final isLoggedIn = false.obs;
  final userName = 'Invitado'.obs;

  Future<AuthService> init() async {
    isLoggedIn.value = _box.read(AppConstants.keyIsLoggedIn) ?? false;
    userName.value = _box.read(AppConstants.keyUserName) ?? 'Invitado';
    return this;
  }

  void login(String user) {
    isLoggedIn.value = true;
    userName.value = user;
    _box.write(AppConstants.keyIsLoggedIn, true);
    _box.write(AppConstants.keyUserName, user);
    Get.offAllNamed(AppRoutes.HOME);
  }

  void logout() {
    isLoggedIn.value = false;
    userName.value = 'Invitado';
    _box.remove(AppConstants.keyIsLoggedIn);
    _box.remove(AppConstants.keyUserName);
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
