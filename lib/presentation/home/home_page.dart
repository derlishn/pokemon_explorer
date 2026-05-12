import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemon_explorer/presentation/layouts/adaptive_layout.dart';
import 'package:pokemon_explorer/services/auth_service.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService.to.logout(),
          ),
        ],
      ),
      body: controller.obx(
        (state) => _buildGrid(state!),
        onLoading: _buildSkeleton(),
        onError: (error) => _buildError(error),
      ),
    );
  }

  Widget _buildGrid(List<dynamic> pokemons) {
    return AdaptiveLayout(
      mobile: _buildGridView(pokemons, 2),
      tablet: _buildGridView(pokemons, 4),
      desktop: _buildGridView(pokemons, 6),
    );
  }

  Widget _buildGridView(List<dynamic> pokemons, int crossAxisCount) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        final pokemon = pokemons[index];
        return _buildPokemonCard(context, pokemon);
      },
    );
  }

  Widget _buildPokemonCard(BuildContext context, dynamic pokemon) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.toNamed('/detail', arguments: pokemon),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: Hero(
                  tag: pokemon.id,
                  child: CachedNetworkImage(
                    imageUrl: pokemon.imageUrl,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                pokemon.name.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return const Center(child: CircularProgressIndicator()); // Will improve with flutter_shimmer later
  }

  Widget _buildError(String? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(error ?? 'error_network'.tr),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.fetchPokemon(),
            child: Text('retry'.tr),
          ),
        ],
      ),
    );
  }
}
