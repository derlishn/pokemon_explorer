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
        padding: const EdgeInsets.only(bottom: 40),
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
          
          // Accent Color Picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text('Color de Acento', style: TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                Wrap(
                  spacing: 8,
                  children: [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple].map((color) {
                    return Obx(() => GestureDetector(
                      onTap: () => SettingsService.to.updateAccentColor(color),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: SettingsService.to.accentColor.value == color.value
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                        ),
                      ),
                    ));
                  }).toList(),
                ),
              ],
            ),
          ),
          const Divider(),

          // Grid Configuration
          _buildSectionHeader(context, 'Layout'),
          Obx(() => ListTile(
            leading: const Icon(Icons.grid_view),
            title: const Text('Columnas en Rejilla'),
            subtitle: Text(SettingsService.to.gridColumns == 0 ? 'Automático' : '${SettingsService.to.gridColumns} Columnas'),
            trailing: DropdownButton<int>(
              value: SettingsService.to.gridColumns,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 0, child: Text('Auto')),
                DropdownMenuItem(value: 2, child: Text('2')),
                DropdownMenuItem(value: 3, child: Text('3')),
                DropdownMenuItem(value: 4, child: Text('4')),
              ],
              onChanged: (val) => SettingsService.to.updateGridColumns(val!),
            ),
          )),
          const Divider(),

          // Language Section
          _buildSectionHeader(context, 'language'.tr),
          _buildLanguageOption(context, 'Español', const Locale('es', 'ES'), '🇪🇸'),
          _buildLanguageOption(context, 'English', const Locale('en', 'US'), '🇺🇸'),
          const Divider(),

          // About the App
          _buildSectionHeader(context, 'Sobre esta App'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(Icons.code, size: 40),
                    SizedBox(height: 12),
                    Text(
                      'Este proyecto es una demostración técnica diseñada para mostrar conocimientos avanzados en Flutter, GetX y arquitectura limpia. Incluye manejo de estado global, persistencia local, diseños adaptativos e integraciones de API.',
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.5),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Desarrollado con ❤️ para demostrar mi pasión por el código de alta calidad.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const Center(
            child: Text(
              'Pokémon Explorer v1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
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
          color: SettingsService.to.accentColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String name, Locale locale, String flag) {
    return Obx(() {
      final isSelected = SettingsService.to.locale.languageCode == locale.languageCode;
      return ListTile(
        leading: Text(flag, style: const TextStyle(fontSize: 24)),
        title: Text(name),
        trailing: isSelected ? Icon(Icons.check_circle, color: SettingsService.to.accentColor) : null,
        onTap: () => SettingsService.to.updateLocale(locale),
      );
    });
  }
}
