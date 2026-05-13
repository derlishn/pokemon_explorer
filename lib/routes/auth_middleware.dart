import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/routes/app_pages.dart';
import 'package:pokemon_explorer/services/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = AuthService.to;
    return authService.isLoggedIn.value
        ? null
        : const RouteSettings(name: AppRoutes.login);
  }
}
