import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/presentation/widgets/empty_state.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/presentation/widgets/pokemon_card.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [_buildAppBar(context), _buildBody(context)],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
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
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      final width = MediaQuery.of(context).size.width;
      final manualColumns = SettingsService.to.gridColumns;
      final int crossAxisCount = manualColumns > 0
          ? manualColumns
          : (width > 1200 ? 6 : (width > 600 ? 4 : 2));

      return SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: PagedSliverGrid<int, PokemonListItemModel>(
          key: ValueKey('grid_$crossAxisCount'),
          pagingController: controller.pagingController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          builderDelegate: PagedChildBuilderDelegate<PokemonListItemModel>(
            itemBuilder: (context, item, index) =>
                _buildAnimatedItem(item, index, crossAxisCount),
            firstPageProgressIndicatorBuilder: (_) =>
                _buildSkeletonLoading(context, crossAxisCount),
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
    });
  }

  Widget _buildAnimatedItem(
    PokemonListItemModel item,
    int index,
    int crossAxisCount,
  ) {
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 600),
      columnCount: crossAxisCount,
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: PokemonCard(
            pokemon: item,
            onTap: () => Get.toNamed('/detail', arguments: item),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: (val) => controller.updateSearch(val),
        decoration: InputDecoration(
          hintText: 'Buscar Pokémon...',
          prefixIcon: const Icon(Icons.search, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading(BuildContext context, int crossAxisCount) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        4,
        (rowIndex) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: List.generate(
              crossAxisCount,
              (colIndex) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: colIndex == crossAxisCount - 1 ? 0 : 16,
                  ),
                  child: _buildSkeletonCard(context),
                ),
              ),
            ),
          ),
        ),
      ),
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
    return const EmptyState(message: 'no_results', icon: Icons.search_off);
  }
}
