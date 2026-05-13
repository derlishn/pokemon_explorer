import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/routes/app_pages.dart';
import 'package:pokemon_explorer/services/auth_service.dart';

class GuestMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = AuthService.to;
    
    // If user is already logged in, send them to home
    return authService.isLoggedIn.value
        ? const RouteSettings(name: AppRoutes.home)
        : null;
  }
}
