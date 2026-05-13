import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
import 'package:pokemon_explorer/core/widgets/empty_state.dart';
import 'package:pokemon_explorer/services/favorites_service.dart';
import 'package:pokemon_explorer/features/favorites/presentation/widgets/favorites_grid.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TranslationKeys.favorites.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final results = FavoritesService.to.favorites.toList();

        if (results.isEmpty) {
          return const EmptyState(
            message: TranslationKeys.noFavorites,
            icon: Icons.favorite_border,
          );
        }

        return FavoritesGrid(items: results);
      }),
    );
  }
}
