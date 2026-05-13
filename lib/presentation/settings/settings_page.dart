import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/presentation/widgets/section_header.dart';
import 'package:pokemon_explorer/presentation/settings/widgets/user_profile_card.dart';
import 'package:pokemon_explorer/presentation/settings/widgets/about_app_card.dart';
import 'package:pokemon_explorer/presentation/layouts/adaptive_layout.dart';
import 'package:pokemon_explorer/presentation/widgets/app_snackbar.dart';
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

  Widget _buildMobileLayout(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
      children: _buildSettingsList(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              UserProfileCard(
                userName: controller.userName,
                onLogout: () => controller.logout(),
              ),
              const SizedBox(height: 32),
              // Using Wrap instead of GridView to avoid infinite constraint issues
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _buildSectionBox(context, 'theme'.tr, 450, [
                    _buildThemeToggle(),
                    const SizedBox(height: 8),
                    _buildAccentColorPicker(context),
                  ]),
                  _buildSectionBox(context, 'storage'.tr, 450, [
                    _buildCacheToggle(context),
                    _buildClearCacheButton(context),
                  ]),
                  _buildSectionBox(context, 'Layout', 450, [
                    _buildGridSelector(),
                  ]),
                  _buildSectionBox(context, 'language'.tr, 450, [
                    _buildLanguageOption(context, 'Español', const Locale('es', 'ES'), '🇪🇸'),
                    _buildLanguageOption(context, 'English', const Locale('en', 'US'), '🇺🇸'),
                  ]),
                ],
              ),
              const SizedBox(height: 48),
              const AboutAppCard(),
            ],
          ),
        ),
      ),
    );
  }

  // A fixed-width box for desktop layout sections
  Widget _buildSectionBox(BuildContext context, String title, double width, List<Widget> children) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
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
          const SizedBox(height: 16),
          ...children,
        ],
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
      SectionHeader(title: 'storage'.tr),
      _buildCacheToggle(context),
      _buildClearCacheButton(context),
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
        SettingsService.to.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
        color: SettingsService.to.themeMode == ThemeMode.dark ? Colors.amber : Colors.blue,
      )),
      title: const Text('Modo Oscuro'),
      trailing: Obx(() => Switch.adaptive(
        value: SettingsService.to.themeMode == ThemeMode.dark,
        onChanged: (val) => SettingsService.to.updateThemeMode(val ? ThemeMode.dark : ThemeMode.light),
      )),
    );
  }

  Widget _buildCacheToggle(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.cached),
      title: Text('use_cache_title'.tr),
      subtitle: Text('use_cache_desc'.tr, style: const TextStyle(fontSize: 12)),
      trailing: Obx(() => Switch.adaptive(
        value: SettingsService.to.useCache,
        onChanged: (val) {
          if (!val) {
            _showCacheWarning(context);
          } else {
            SettingsService.to.updateUseCache(true);
          }
        },
      )),
    );
  }

  Widget _buildClearCacheButton(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
      title: Text('clear_cache_title'.tr),
      subtitle: Text('clear_cache_desc'.tr, style: const TextStyle(fontSize: 12)),
      onTap: () => _showClearCacheConfirm(context),
    );
  }

  void _showCacheWarning(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 10),
            Text('cache_warning_title'.tr),
          ],
        ),
        content: Text('cache_warning_msg'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
            onPressed: () {
              SettingsService.to.updateUseCache(false);
              Get.back();
            },
            child: Text('disable'.tr),
          ),
        ],
      ),
    );
  }

  void _showClearCacheConfirm(BuildContext context) {
    final count = SettingsService.to.getCachedCount();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('clear_cache_confirm_title'.tr),
        content: Text('clear_cache_confirm_msg'.tr.replaceFirst('@count', count.toString())),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () {
              SettingsService.to.clearCache();
              Get.back();
              AppSnackbar.success(
                title: 'Caché Limpia',
                message: 'Se han borrado los datos correctamente.',
              );
            },
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildAccentColorPicker(BuildContext context) {
    final colors = [Colors.grey, Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color de Acento', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors.map((color) {
            return Obx(() => GestureDetector(
              onTap: () => SettingsService.to.updateAccentColor(color),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: SettingsService.to.accentColor == color
                      ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3)
                      : null,
                ),
              ),
            ));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGridSelector() {
    return Obx(() {
      final allowedValues = [0, 1, 2];
      int currentValue = SettingsService.to.gridColumns;
      
      // Safety check: if value is not in [0, 1, 2], return a simple text or fix it
      if (!allowedValues.contains(currentValue)) {
        return const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.grid_view),
          title: Text('Columnas en Rejilla'),
          subtitle: Text('Cargando...'),
        );
      }

      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.grid_view),
        title: const Text('Columnas en Rejilla'),
        subtitle: Text(currentValue == 0 ? 'Automático' : '$currentValue Columnas'),
        trailing: DropdownButton<int>(
          value: currentValue,
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(value: 0, child: Text('Auto')),
            DropdownMenuItem(value: 1, child: Text('1')),
            DropdownMenuItem(value: 2, child: Text('2')),
          ],
          onChanged: (val) => SettingsService.to.updateGridColumns(val!),
        ),
      );
    });
  }

  Widget _buildLanguageOption(BuildContext context, String name, Locale locale, String flag) {
    return Obx(() {
      final isSelected = SettingsService.to.locale.languageCode == locale.languageCode;
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Text(flag, style: const TextStyle(fontSize: 24)),
        title: Text(name),
        trailing: isSelected ? Icon(Icons.check_circle, color: SettingsService.to.accentColor) : null,
        onTap: () {
          Get.updateLocale(locale);
          SettingsService.to.updateLocale(locale);
        },
      );
    });
  }
}
