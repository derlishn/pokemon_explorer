import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
import 'package:pokemon_explorer/services/settings_service.dart';

class ThemeSection extends StatelessWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildThemeToggle(),
        const SizedBox(height: 16),
        _buildAccentColorPicker(context),
      ],
    );
  }

  Widget _buildThemeToggle() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Obx(() => Icon(
            SettingsService.to.themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode,
            color: SettingsService.to.themeMode == ThemeMode.dark
                ? Colors.amber
                : Colors.blue,
          )),
      title: Text(TranslationKeys.darkMode.tr),
      trailing: Obx(() => Switch.adaptive(
            value: SettingsService.to.themeMode == ThemeMode.dark,
            onChanged: (val) => SettingsService.to
                .updateThemeMode(val ? ThemeMode.dark : ThemeMode.light),
          )),
    );
  }

  Widget _buildAccentColorPicker(BuildContext context) {
    final colors = [
      Colors.grey,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TranslationKeys.accentColor.tr,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
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
                          ? Border.all(
                              color: Theme.of(context).colorScheme.onSurface,
                              width: 3,
                            )
                          : null,
                    ),
                  ),
                ));
          }).toList(),
        ),
      ],
    );
  }
}
