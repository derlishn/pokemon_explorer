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
import 'package:pokemon_explorer/routes/guest_middleware.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static const _defaultTransition = Transition.cupertino;
  static const _defaultTransitionDuration = Duration(milliseconds: 400);

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
      transition: _defaultTransition,
      transitionDuration: _defaultTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
      transition: _defaultTransition,
      transitionDuration: _defaultTransitionDuration,
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: _defaultTransition,
      transitionDuration: _defaultTransitionDuration,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () => const DetailPage(),
      binding: DetailBinding(),
      transition: Transition.fadeIn, // Fade is better for detail views
      transitionDuration: _defaultTransitionDuration,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => const FavoritesPage(),
      binding: FavoritesBinding(),
      transition: _defaultTransition,
      transitionDuration: _defaultTransitionDuration,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      transition: _defaultTransition,
      transitionDuration: _defaultTransitionDuration,
      middlewares: [AuthMiddleware()],
    ),
  ];
}
