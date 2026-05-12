import 'package:get/get.dart';
import 'package:pokemon_explorer/presentation/home/home_binding.dart';
import 'package:pokemon_explorer/presentation/home/home_page.dart';
import 'package:pokemon_explorer/presentation/login/login_binding.dart';
import 'package:pokemon_explorer/presentation/login/login_page.dart';
import 'package:pokemon_explorer/presentation/splash/splash_binding.dart';
import 'package:pokemon_explorer/presentation/splash/splash_page.dart';
import 'package:pokemon_explorer/routes/auth_middleware.dart';

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
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
