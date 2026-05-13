import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pokemon_explorer/core/widgets/empty_state.dart';
import 'package:pokemon_explorer/services/favorites_service.dart';
import 'package:pokemon_explorer/core/widgets/pokemon_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'favorites'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final results = FavoritesService.to.favorites.toList();

        if (results.isEmpty) {
          return const EmptyState(
            message: 'No tienes favoritos aún',
            icon: Icons.favorite_border,
          );
        }

        final width = MediaQuery.of(context).size.width;
        final int crossAxisCount = width > 1200 ? 6 : (width > 600 ? 4 : 2);

        return AnimationLimiter(
          key: ValueKey(results.length),
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
                    child: PokemonCard(
                      pokemon: pokemon,
                      onTap: () => Get.toNamed('/detail', arguments: pokemon),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
