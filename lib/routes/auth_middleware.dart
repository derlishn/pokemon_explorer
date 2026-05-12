import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import 'app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return AuthService.to.isLoggedIn
        ? null
        : const RouteSettings(name: AppRoutes.LOGIN);
  }
}
