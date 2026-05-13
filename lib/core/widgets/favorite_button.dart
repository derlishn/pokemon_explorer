import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/services/favorites_service.dart';

class FavoriteButton extends StatelessWidget {
  final int pokemonId;
  final dynamic pokemonData;
  final double size;

  const FavoriteButton({
    super.key,
    required this.pokemonId,
    required this.pokemonData,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isFav = FavoritesService.to.isFavorite(pokemonId);
      return IconButton(
        icon: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          color: isFav ? Colors.red : Colors.white,
          size: size,
        ),
        onPressed: () => FavoritesService.to.toggleFavorite(pokemonData),
      );
    });
  }
}
