import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print('SPLASH_DEBUG: Controller initialized');
    _navigateToNext();
  }

  void _navigateToNext() async {
    print('SPLASH_DEBUG: Starting timer...');
    await Future.delayed(const Duration(seconds: 3));
    print('SPLASH_DEBUG: Timer finished, navigating...');
    if (AuthService.to.isLoggedIn) {
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
