import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 140.0,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            title: Text(
              'home'.tr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                tooltip: 'favorites'.tr,
                onPressed: () => Get.toNamed('/favorites'),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'settings'.tr,
                onPressed: () => Get.toNamed('/settings'),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: _buildSearchBar(context),
                  ),
                ],
              ),
            ),
          ),
          
          Obx(() {
            final width = MediaQuery.of(context).size.width;
            // Use manual setting if it's not 0, otherwise use adaptive logic
            final manualColumns = SettingsService.to.gridColumns;
            final int crossAxisCount = manualColumns > 0 
                ? manualColumns 
                : (width > 1200 ? 6 : (width > 600 ? 4 : 2));

            if (controller.isSearching.value) {
              return _buildSearchResults(context, crossAxisCount);
            }
            
            return SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: PagedSliverGrid<int, PokemonListItemModel>(
                key: ValueKey('grid_$crossAxisCount'), // Force grid refresh on column change
                pagingController: controller.pagingController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                builderDelegate: PagedChildBuilderDelegate<PokemonListItemModel>(
                  itemBuilder: (context, item, index) => AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 600),
                    columnCount: crossAxisCount,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: _buildPokemonCard(context, item),
                      ),
                    ),
                  ),
                  firstPageProgressIndicatorBuilder: (_) => _buildSkeletonLoading(context, crossAxisCount),
                  newPageProgressIndicatorBuilder: (_) => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  noItemsFoundIndicatorBuilder: (_) => _buildEmptyState(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'search_hint'.tr,
          prefixIcon: const Icon(Icons.search, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, int crossAxisCount) {
    final results = controller.filteredPokemon;
    if (results.isEmpty) return SliverFillRemaining(child: _buildEmptyState());

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        key: ValueKey('search_$crossAxisCount'),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 400),
            columnCount: crossAxisCount,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: _buildPokemonCard(context, results[index]),
              ),
            ),
          ),
          childCount: results.length,
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading(BuildContext context, int crossAxisCount) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (rowIndex) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: List.generate(crossAxisCount, (colIndex) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: colIndex == crossAxisCount - 1 ? 0 : 16,
              ),
              child: _buildSkeletonCard(context),
            ),
          )),
        ),
      )),
    );
  }

  Widget _buildSkeletonCard(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3);
    return AspectRatio(
      aspectRatio: 0.85,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('no_results'.tr),
        ],
      ),
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
