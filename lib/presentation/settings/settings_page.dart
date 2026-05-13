import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/presentation/widgets/section_header.dart';
import 'package:pokemon_explorer/presentation/settings/widgets/user_profile_card.dart';
import 'package:pokemon_explorer/presentation/settings/widgets/about_app_card.dart';
import 'settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
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
          const SectionHeader(title: 'Usuario'),
          Obx(() => UserProfileCard(
            userName: controller.userName,
            onLogout: () => controller.logout(),
          )),
          const Divider(),

          // Appearance Section
          SectionHeader(title: 'theme'.tr),
          _buildThemeToggle(),
          _buildAccentColorPicker(context),
          const Divider(),

          // Layout Section
          const SectionHeader(title: 'Layout'),
          _buildGridSelector(),
          const Divider(),

          // Language Section
          SectionHeader(title: 'language'.tr),
          _buildLanguageOption(context, 'Español', const Locale('es', 'ES'), '🇪🇸'),
          _buildLanguageOption(context, 'English', const Locale('en', 'US'), '🇺🇸'),
          const Divider(),

          // About Section
          const SectionHeader(title: 'Sobre esta App'),
          const AboutAppCard(),
          
          const Center(
            child: Text(
              'Pokémon Explorer v1.1.0',
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

  Widget _buildAccentColorPicker(BuildContext context) {
    return Padding(
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
    );
  }

  Widget _buildGridSelector() {
    return Obx(() => ListTile(
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
    ));
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
