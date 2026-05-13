import 'package:get/get.dart';
import 'package:pokemon_explorer/features/splash/presentation/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }
}
