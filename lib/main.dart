import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/helpers/dependency_injection.dart';
import 'package:pokemon_explorer/helpers/translations.dart';
import 'package:pokemon_explorer/routes/app_pages.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // High-level dependency initialization
  await DependencyInjection.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsService = Get.find<SettingsService>();
    
    return GetMaterialApp(
      title: 'app_name'.tr,
      debugShowCheckedModeBanner: false,
      
      // Theme Configuration
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settingsService.themeMode,
      
      // i18n Configuration
      translations: AppTranslations(),
      locale: settingsService.locale,
      fallbackLocale: const Locale('en', 'US'),
      
      // Routing
      getPages: AppPages.routes,
      initialRoute: AppRoutes.SPLASH,
      
      // Global configuration
      defaultTransition: Transition.cupertino,
    );
  }
}
