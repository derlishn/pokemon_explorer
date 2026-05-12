import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/auth_service.dart';
import '../services/global_service.dart';
import '../services/settings_service.dart';

class DependencyInjection {
  static Future<void> init() async {
    // 1. Storage
    await GetStorage.init();

    // 2. Global Services (Initialized in order)
    await Get.putAsync(() => GlobalService().init());
    await Get.putAsync(() => AuthService().init());
    await Get.putAsync(() => SettingsService().init());
  }
}
