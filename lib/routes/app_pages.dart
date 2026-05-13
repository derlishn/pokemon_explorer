import 'package:get/get.dart';
import 'package:pokemon_explorer/presentation/home/home_binding.dart';
import 'package:pokemon_explorer/presentation/home/home_page.dart';
import 'package:pokemon_explorer/presentation/login/login_binding.dart';
import 'package:pokemon_explorer/presentation/login/login_page.dart';
import 'package:pokemon_explorer/presentation/splash/splash_binding.dart';
import 'package:pokemon_explorer/presentation/splash/splash_page.dart';
import 'package:pokemon_explorer/presentation/detail/detail_binding.dart';
import 'package:pokemon_explorer/presentation/detail/detail_page.dart';
import 'package:pokemon_explorer/presentation/favorites/favorites_page.dart';
import 'package:pokemon_explorer/presentation/favorites/favorites_binding.dart';
import 'package:pokemon_explorer/presentation/settings/settings_page.dart';
import 'package:pokemon_explorer/presentation/settings/settings_binding.dart';
import 'auth_middleware.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH;

  static final routes = [
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
    GetPage(
      name: AppRoutes.DETAIL,
      page: () => const DetailPage(),
      binding: DetailBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.FAVORITES,
      page: () => const FavoritesPage(),
      binding: FavoritesBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
