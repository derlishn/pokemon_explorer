import 'package:flutter/material.dart';
import 'package:pokemon_explorer/services/settings_service.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool useAccentColor;

  const SectionHeader({
    super.key,
    required this.title,
    this.useAccentColor = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: useAccentColor 
              ? SettingsService.to.accentColor 
              : Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
