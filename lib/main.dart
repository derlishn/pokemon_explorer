import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pokemon_explorer/helpers/translations.dart';
import 'package:pokemon_explorer/routes/app_pages.dart';
import 'package:pokemon_explorer/services/global_service.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Storage
  await GetStorage.init();
  
  // Initialize Services
  await Get.putAsync(() => GlobalService().init());
  final settingsService = await Get.putAsync(() => SettingsService().init());
  
  runApp(MyApp(settingsService: settingsService));
}

class MyApp extends StatelessWidget {
  final SettingsService settingsService;
  
  const MyApp({super.key, required this.settingsService});

  @override
  Widget build(BuildContext context) {
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
      
      // Default transition for premium feel
      defaultTransition: Transition.cupertino,
      
      // Temp home until Splash is implemented
      home: Scaffold(
        body: Center(
          child: Text('app_name'.tr, style: const TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}
