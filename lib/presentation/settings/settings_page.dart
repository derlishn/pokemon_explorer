import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/presentation/widgets/section_header.dart';
import 'package:pokemon_explorer/presentation/settings/widgets/user_profile_card.dart';
import 'package:pokemon_explorer/presentation/settings/widgets/about_app_card.dart';
import 'package:pokemon_explorer/presentation/layouts/adaptive_layout.dart';
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
      body: AdaptiveLayout(
        mobile: _buildMobileLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  // --- MOBILE LAYOUT (Classic List) ---
  Widget _buildMobileLayout(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
      children: _buildSettingsList(context),
    );
  }

  // --- DESKTOP LAYOUT (Grid Dashboard) ---
  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            // Hero Profile Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: UserProfileCard(
                  userName: controller.userName,
                  onLogout: () => controller.logout(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Settings Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                children: [
                  _buildSectionCard(context, 'theme'.tr, [
                    _buildThemeToggle(),
                    _buildAccentColorPicker(context),
                  ]),
                  _buildSectionCard(context, 'Layout', [
                    _buildGridSelector(),
                  ]),
                  _buildSectionCard(context, 'language'.tr, [
                    _buildLanguageOption(context, 'Español', const Locale('es', 'ES'), '🇪🇸'),
                    _buildLanguageOption(context, 'English', const Locale('en', 'US'), '🇺🇸'),
                  ]),
                  _buildSectionCard(context, 'Sobre esta App', [
                    const Expanded(child: SingleChildScrollView(child: AboutAppCard())),
                  ]),
                ],
              ),
            ),
            const Text(
              'Pokémon Explorer v1.1.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: SettingsService.to.accentColor,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 15),
            ...children,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSettingsList(BuildContext context) {
    return [
      const SectionHeader(title: 'Usuario'),
      Obx(() => UserProfileCard(
        userName: controller.userName,
        onLogout: () => controller.logout(),
      )),
      const Divider(),
      SectionHeader(title: 'theme'.tr),
      _buildThemeToggle(),
      _buildAccentColorPicker(context),
      const Divider(),
      const SectionHeader(title: 'Layout'),
      _buildGridSelector(),
      const Divider(),
      SectionHeader(title: 'language'.tr),
      _buildLanguageOption(context, 'Español', const Locale('es', 'ES'), '🇪🇸'),
      _buildLanguageOption(context, 'English', const Locale('en', 'US'), '🇺🇸'),
      const Divider(),
      const SectionHeader(title: 'Sobre esta App'),
      const AboutAppCard(),
    ];
  }

  Widget _buildThemeToggle() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
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
    final colors = [Colors.grey, Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple];
    return Row(
      children: [
        const Text('Color de Acento', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(width: 10),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 8,
            children: colors.map((color) {
              return Obx(() => GestureDetector(
                onTap: () => SettingsService.to.updateAccentColor(color),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: SettingsService.to.accentColor.value == color.value
                        ? Border.all(color: Theme.of(context).colorScheme.onBackground, width: 2)
                        : null,
                  ),
                ),
              ));
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGridSelector() {
    return Obx(() => ListTile(
      contentPadding: EdgeInsets.zero,
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
        contentPadding: EdgeInsets.zero,
        leading: Text(flag, style: const TextStyle(fontSize: 24)),
        title: Text(name),
        trailing: isSelected ? Icon(Icons.check_circle, color: SettingsService.to.accentColor) : null,
        onTap: () => SettingsService.to.updateLocale(locale),
      );
    });
  }
}
