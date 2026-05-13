import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';
import 'package:pokemon_explorer/core/theme/app_colors.dart';
import 'package:pokemon_explorer/core/utils/hero_tags.dart';

class PokemonCard extends StatelessWidget {
  final PokemonListItemModel pokemon;
  final VoidCallback onTap;
  final String? heroTag;

  const PokemonCard({
    super.key, 
    required this.pokemon, 
    required this.onTap,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Use utility for fallback to avoid hardcoded prefixes
    final tag = heroTag ?? HeroTags.getDefaultTag(pokemon.id);

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Icon(
                      Icons.catching_pokemon,
                      size: 100,
                      color: colorScheme.primary.withValues(alpha: 0.08),
                    ),
                  ),
                  Center(
                    child: Hero(
                      tag: tag,
                      child: CachedNetworkImage(
                        imageUrl: pokemon.imageUrl,
                        height: 120,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    pokemon.name.capitalizeFirst!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 4,
                    runSpacing: 4,
                    children: pokemon.types
                        .take(2)
                        .map(
                          (type) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.getTypeColor(
                                type,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: AppColors.getTypeColor(type),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              type.toUpperCase(),
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: AppColors.getTypeColor(type),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
