import 'package:get/get.dart';
import 'package:pokemon_explorer/features/settings/presentation/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
