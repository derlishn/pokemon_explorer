import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../presentation/login/login_binding.dart';
import '../presentation/login/login_page.dart';
import '../presentation/splash/splash_binding.dart';
import '../presentation/splash/splash_page.dart';

class AppRoutes {
  static const String SPLASH = '/';
  static const String LOGIN = '/login';
  static const String HOME = '/home';
  static const String DETAIL = '/detail';
}

class AppPages {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    // Placeholder for HOME to test navigation
    GetPage(
      name: AppRoutes.HOME,
      page: () => const Center(child: Text('Home')),
    ),
  ];
}
