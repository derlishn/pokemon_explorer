import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
import 'package:pokemon_explorer/core/widgets/rotating_pokeball.dart';

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final IconData icon;

  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.icon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                RotatingPokeball(
                  size: 140,
                  opacity: 0.1,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Icon(
                  message == TranslationKeys.noCacheAvailable.tr || 
                  message == TranslationKeys.noResults.tr
                      ? Icons.cloud_off_rounded 
                      : icon,
                  size: 64,
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.8),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              message == TranslationKeys.noCacheAvailable.tr ||
              message == TranslationKeys.noResults.tr
                  ? TranslationKeys.noConnectionTitle.tr 
                  : TranslationKeys.errorUnknown.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message.contains('NoSuchMethodError') || message.contains('null')
                  ? TranslationKeys.errorServer.tr
                  : message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
