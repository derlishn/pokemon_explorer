import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';
import 'package:pokemon_explorer/core/widgets/rotating_pokeball.dart';
import 'package:pokemon_explorer/core/widgets/favorite_button.dart';

class DetailAppBar extends StatelessWidget {
  final PokemonDetailModel pokemon;
  final Color themeColor;
  final String heroTag;

  const DetailAppBar({
    super.key,
    required this.pokemon,
    required this.themeColor,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: themeColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            const RotatingPokeball(size: 300, opacity: 0.2),
            Center(
              child: Hero(
                tag: heroTag,
                child: CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        FavoriteButton(
          pokemonId: pokemon.id,
          pokemonData: pokemon,
        ),
      ],
    );
  }
}
