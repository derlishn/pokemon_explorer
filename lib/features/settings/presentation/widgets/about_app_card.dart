import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';

class AboutAppCard extends StatelessWidget {
  const AboutAppCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(Icons.code, size: 40, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                TranslationKeys.aboutAppDesc.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(height: 1.5),
              ),
              const SizedBox(height: 12),
              Text(
                TranslationKeys.devSignature.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
