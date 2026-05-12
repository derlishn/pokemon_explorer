import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemon_explorer/data/models/pokemon_detail_model.dart';
import 'package:pokemon_explorer/helpers/app_colors.dart';
import 'detail_controller.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: controller.obx(
        (state) => _buildDetail(context, state!),
        onLoading: _buildLoading(context),
        onError: (error) => _buildError(context, error),
      ),
    );
  }

  Widget _buildDetail(BuildContext context, PokemonDetailModel pokemon) {
    final primaryType = pokemon.types.first.name;
    final themeColor = AppColors.getTypeColor(primaryType);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: themeColor,
          foregroundColor: Colors.white, // Keep back button white for contrast
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.catching_pokemon,
                    size: 250,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                Center(
                  child: Hero(
                    tag: 'pokemon_${pokemon.id}',
                    child: CachedNetworkImage(
                      imageUrl: pokemon.imageUrl,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pokemon.name.toUpperCase(),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        pokemon.formattedId,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTypeBadges(pokemon),
                  const SizedBox(height: 24),
                  _buildAbout(context, pokemon),
                  const SizedBox(height: 24),
                  Text(
                    'base_stats'.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildStats(context, pokemon),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeBadges(PokemonDetailModel pokemon) {
    return Wrap(
      spacing: 8,
      children: pokemon.types
          .map((t) => Chip(
                label: Text(t.name.toUpperCase(), style: const TextStyle(color: Colors.white)),
                backgroundColor: AppColors.getTypeColor(t.name),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ))
          .toList(),
    );
  }

  Widget _buildAbout(BuildContext context, PokemonDetailModel pokemon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildInfoColumn(context, 'weight'.tr, '${pokemon.weight / 10} kg', Icons.monitor_weight),
        _buildInfoColumn(context, 'height'.tr, '${pokemon.height / 10} m', Icons.height),
      ],
    );
  }

  Widget _buildInfoColumn(BuildContext context, String label, String value, IconData icon) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: onSurface.withOpacity(0.6)),
            const SizedBox(width: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: onSurface.withOpacity(0.5), fontSize: 12)),
      ],
    );
  }

  Widget _buildStats(BuildContext context, PokemonDetailModel pokemon) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      children: pokemon.stats
          .map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        s.name.toUpperCase(), 
                        style: TextStyle(color: onSurface.withOpacity(0.6), fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        s.value.toString(), 
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: s.value / 150,
                          backgroundColor: onSurface.withOpacity(0.1),
                          color: AppColors.getTypeColor(pokemon.types.first.name),
                          minHeight: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(BuildContext context, String? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(error ?? 'Error'),
          TextButton(onPressed: () => controller.fetchDetail(), child: Text('retry'.tr)),
        ],
      ),
    );
  }
}
