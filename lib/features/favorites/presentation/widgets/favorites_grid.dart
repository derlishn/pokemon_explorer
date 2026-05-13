import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';
import 'package:pokemon_explorer/core/widgets/pokemon_card.dart';
import 'package:pokemon_explorer/routes/app_pages.dart';

class FavoritesGrid extends StatelessWidget {
  final List<PokemonListItemModel> items;

  const FavoritesGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final int crossAxisCount = width > 1200 ? 6 : (width > 600 ? 4 : 2);

        return AnimationLimiter(
          key: ValueKey(items.length),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.72,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final pokemon = items[index];
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 500),
                columnCount: crossAxisCount,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: PokemonCard(
                      pokemon: pokemon,
                      onTap: () => Get.toNamed(
                        AppRoutes.detail,
                        arguments: pokemon,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
