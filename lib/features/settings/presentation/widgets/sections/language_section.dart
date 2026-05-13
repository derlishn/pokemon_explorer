import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/services/settings_service.dart';

class LanguageSection extends StatelessWidget {
  const LanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildOption(context, 'Español', const Locale('es', 'ES'), '🇪🇸'),
        _buildOption(context, 'English', const Locale('en', 'US'), '🇺🇸'),
      ],
    );
  }

  Widget _buildOption(
    BuildContext context,
    String name,
    Locale locale,
    String flag,
  ) {
    return Obx(() {
      final isSelected =
          SettingsService.to.locale.languageCode == locale.languageCode;
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Text(flag, style: const TextStyle(fontSize: 24)),
        title: Text(name),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: SettingsService.to.accentColor)
            : null,
        onTap: () {
          Get.updateLocale(locale);
          SettingsService.to.updateLocale(locale);
        },
      );
    });
  }
}
