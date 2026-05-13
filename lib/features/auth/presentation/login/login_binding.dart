import 'package:get/get.dart';
import 'package:pokemon_explorer/features/auth/presentation/login/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
