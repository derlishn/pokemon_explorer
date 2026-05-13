import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pokemon_explorer/helpers/dependency_injection.dart';
import 'package:pokemon_explorer/helpers/translations.dart';
import 'package:pokemon_explorer/routes/app_pages.dart';
import 'package:pokemon_explorer/services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await DependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsService = SettingsService.to;

    return Obx(() => GetMaterialApp(
      title: 'Pokémon Explorer',
      debugShowCheckedModeBanner: false,
      
      // Dynamic Theme based on Accent Color
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: settingsService.accentColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: settingsService.accentColor,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: settingsService.themeMode,
      
      // Localization
      translations: AppTranslations(),
      locale: settingsService.locale,
      fallbackLocale: const Locale('en', 'US'),
      
      // Routing
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    ));
  }
}
