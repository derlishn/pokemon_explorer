import 'package:get/get.dart';
import 'package:pokemon_explorer/services/auth_service.dart';

class SettingsController extends GetxController {
  void logout() {
    AuthService.to.logout();
  }
  
  String get userName => AuthService.to.userName.value;
}
