import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pokemon_explorer/core/di/dependency_injection.dart';
import 'package:pokemon_explorer/core/translations/translations.dart';
import 'package:pokemon_explorer/core/constants/constants.dart';
import 'package:pokemon_explorer/routes/app_pages.dart';
import 'package:pokemon_explorer/services/settings_service.dart';

void main() async {
  // Ensure Flutter is initialized before anything else
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage engine
  await GetStorage.init();

  // Initialize dependency injection container
  await DependencyInjection.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsService = SettingsService.to;

    return Obx(
      () => GetMaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,

        // Dynamic Design System (Theming)
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: settingsService.accentColor,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(centerTitle: true),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: settingsService.accentColor,
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(centerTitle: true),
        ),
        themeMode: settingsService.themeMode,

        // Multi-language Configuration
        translations: AppTranslations(),
        locale: settingsService.locale,
        fallbackLocale: const Locale(
          AppConstants.fallbackLanguageCode,
          AppConstants.fallbackCountryCode,
        ), // Standard international fallback
        // Routing Engine
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,

        // Global Focus Management
        builder: (context, child) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
