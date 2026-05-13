import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pokemon_explorer/services/favorites_service.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final int crossAxisCount = width > 1200 ? 6 : (width > 600 ? 4 : 2);

    return Scaffold(
      appBar: AppBar(
        title: Text('favorites'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Obx(() {
        // Accessing the list explicitly to trigger reactivity
        final results = FavoritesService.to.favorites.toList();
        
        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                const SizedBox(height: 20),
                Text(
                  'No tienes favoritos todavía'.tr,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return AnimationLimiter(
          key: ValueKey(results.length), // Key ensures fresh animation on count change
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final pokemon = results[index];
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 500),
                columnCount: crossAxisCount,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: _buildPokemonCard(context, pokemon),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildPokemonCard(BuildContext context, PokemonListItemModel pokemon) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: () => Get.toNamed('/detail', arguments: pokemon),
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
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  Center(
                    child: Hero(
                      tag: 'pokemon_${pokemon.id}',
                      child: CachedNetworkImage(
                        imageUrl: pokemon.imageUrl,
                        height: 120,
                        fit: BoxFit.contain,
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
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
              ),
              child: Text(
                pokemon.name.capitalizeFirst!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
