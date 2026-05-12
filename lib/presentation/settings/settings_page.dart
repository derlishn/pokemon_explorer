import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/services/auth_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // User Section
          _buildSectionHeader(context, 'user'.tr),
          Obx(() => ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(AuthService.to.userName.value),
            subtitle: const Text('Entrenador Pokémon'),
            trailing: IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () => AuthService.to.logout(),
            ),
          )),
          const Divider(),

          // Appearance Section
          _buildSectionHeader(context, 'theme'.tr),
          _buildThemeToggle(),
          const Divider(),

          // Language Section
          _buildSectionHeader(context, 'language'.tr),
          _buildLanguageOption(
            context,
            'Español',
            const Locale('es', 'ES'),
            '🇪🇸',
          ),
          _buildLanguageOption(
            context,
            'English',
            const Locale('en', 'US'),
            '🇺🇸',
          ),
          
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Pokémon Explorer v1.0.0',
              style: TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle() {
    return ListTile(
      leading: Obx(() => Icon(
        SettingsService.to.isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: SettingsService.to.isDarkMode ? Colors.amber : Colors.blue,
      )),
      title: const Text('Modo Oscuro'),
      trailing: Obx(() => Switch.adaptive(
        value: SettingsService.to.isDarkMode,
        onChanged: (_) => SettingsService.to.toggleTheme(),
      )),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, 
    String name, 
    Locale locale, 
    String flag,
  ) {
    return Obx(() {
      final isSelected = SettingsService.to.locale.languageCode == locale.languageCode;
      return ListTile(
        leading: Text(flag, style: const TextStyle(fontSize: 24)),
        title: Text(name),
        trailing: isSelected ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor) : null,
        onTap: () => SettingsService.to.updateLocale(locale),
      );
    });
  }
}
