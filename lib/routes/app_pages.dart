import 'package:get/get.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/home/home_binding.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/home/home_page.dart';
import 'package:pokemon_explorer/features/auth/presentation/login/login_binding.dart';
import 'package:pokemon_explorer/features/auth/presentation/login/login_page.dart';
import 'package:pokemon_explorer/features/splash/presentation/splash_binding.dart';
import 'package:pokemon_explorer/features/splash/presentation/splash_page.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/detail/detail_binding.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/detail/detail_page.dart';
import 'package:pokemon_explorer/features/favorites/presentation/favorites_page.dart';
import 'package:pokemon_explorer/features/favorites/presentation/favorites_binding.dart';
import 'package:pokemon_explorer/features/settings/presentation/settings_page.dart';
import 'package:pokemon_explorer/features/settings/presentation/settings_binding.dart';
import 'package:pokemon_explorer/routes/auth_middleware.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () => const DetailPage(),
      binding: DetailBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => const FavoritesPage(),
      binding: FavoritesBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
