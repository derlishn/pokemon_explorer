import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/presentation/widgets/empty_state.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/presentation/widgets/pokemon_card.dart';
import 'package:pokemon_explorer/routes/app_pages.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adaptive Grid Columns
            final int manualColumns = SettingsService.to.gridColumns;
            final double width = constraints.maxWidth;
            final int crossAxisCount = manualColumns > 0 
                ? manualColumns 
                : (width > 1200 ? 6 : (width > 600 ? 4 : 2));

            return CustomScrollView(
              slivers: [
                _buildAppBar(context),
                _buildGrid(crossAxisCount),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 140,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        'app_name'.tr,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () => Get.toNamed(AppRoutes.FAVORITES),
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Get.toNamed(AppRoutes.SETTINGS),
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

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: (val) => controller.updateSearch(val),
        decoration: InputDecoration(
          hintText: 'search_hint'.tr,
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: Obx(() => controller.isSearching.value
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                )
              : const SizedBox.shrink()),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildGrid(int crossAxisCount) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: PagedSliverGrid<int, PokemonListItemModel>(
        pagingController: controller.pagingController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.72, // Space to avoid overflow
        ),
        builderDelegate: PagedChildBuilderDelegate<PokemonListItemModel>(
          itemBuilder: (context, item, index) =>
              _buildAnimatedItem(context, item, index, crossAxisCount),
          noItemsFoundIndicatorBuilder: (_) => const EmptyState(),
          firstPageProgressIndicatorBuilder: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          newPageProgressIndicatorBuilder: (_) => const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedItem(BuildContext context, PokemonListItemModel item,
      int index, int crossAxisCount) {
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 600),
      columnCount: crossAxisCount,
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: PokemonCard(
            pokemon: item,
            onTap: () => Get.toNamed(AppRoutes.DETAIL, arguments: item),
          ),
        ),
      ),
    );
  }
}
