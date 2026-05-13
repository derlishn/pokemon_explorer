import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemon_explorer/data/models/pokemon_detail_model.dart';
import 'package:pokemon_explorer/core/theme/app_colors.dart';
import 'package:pokemon_explorer/presentation/layouts/adaptive_layout.dart';
import 'package:pokemon_explorer/services/favorites_service.dart';
import 'package:pokemon_explorer/presentation/widgets/rotating_pokeball.dart';
import 'package:pokemon_explorer/presentation/detail/widgets/about_tab.dart';
import 'package:pokemon_explorer/presentation/detail/widgets/stats_tab.dart';
import 'package:pokemon_explorer/presentation/detail/widgets/abilities_tab.dart';
import 'package:pokemon_explorer/presentation/detail/detail_controller.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.obx(
        (state) => AdaptiveLayout(
          mobile: _buildMobileLayout(context, state),
          desktop: _buildDesktopLayout(context, state),
        ),
        onLoading: const Center(child: CircularProgressIndicator()),
        onError: (error) => Center(child: Text(error ?? 'Error')),
      ),
    );
  }

  // --- DESKTOP LAYOUT (Split View) ---
  Widget _buildDesktopLayout(BuildContext context, PokemonDetailModel? pokemon) {
    if (pokemon == null) return const SizedBox.shrink();
    final themeColor = AppColors.getTypeColor(pokemon.types.first.name);
    
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            color: themeColor,
            child: Stack(
              children: [
                const RotatingPokeball(size: 600, opacity: 0.1),
                Center(
                  child: Hero(
                    tag: 'pokemon_${pokemon.id}',
                    child: CachedNetworkImage(
                      imageUrl: pokemon.imageUrl,
                      width: 450,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                _buildDesktopActions(pokemon),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: _buildInfoContent(context, pokemon, isDesktop: true),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopActions(PokemonDetailModel pokemon) {
    return Stack(
      children: [
        Positioned(
          top: 40,
          left: 40,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
            onPressed: () => Get.back(),
          ),
        ),
        Positioned(
          top: 40,
          right: 40,
          child: Obx(() {
            final isFav = FavoritesService.to.isFavorite(pokemon.id);
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.white,
                size: 35,
              ),
              onPressed: () => FavoritesService.to.toggleFavorite(controller.initialData),
            );
          }),
        ),
      ],
    );
  }

  // --- MOBILE LAYOUT (NestedScrollView) ---
  Widget _buildMobileLayout(BuildContext context, PokemonDetailModel? pokemon) {
    if (pokemon == null) return const SizedBox.shrink();
    final themeColor = AppColors.getTypeColor(pokemon.types.first.name);

    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildMobileAppBar(pokemon, themeColor),
          _buildMobileTitleSection(context, pokemon),
          _buildMobileTabs(context, themeColor),
        ],
        body: Container(
          color: Theme.of(context).colorScheme.surface,
          child: TabBarView(
            children: [
              AboutTab(pokemon: pokemon),
              StatsTab(pokemon: pokemon),
              AbilitiesTab(pokemon: pokemon),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileAppBar(PokemonDetailModel pokemon, Color themeColor) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: themeColor,
      elevation: 0,
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
                tag: 'pokemon_${pokemon.id}',
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
        Obx(() {
          final isFav = FavoritesService.to.isFavorite(pokemon.id);
          return IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.white,
            ),
            onPressed: () => FavoritesService.to.toggleFavorite(controller.initialData),
          );
        }),
      ],
    );
  }

  Widget _buildMobileTitleSection(BuildContext context, PokemonDetailModel pokemon) {
    return SliverToBoxAdapter(
      child: Container(
        transform: Matrix4.translationValues(0, -30, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 45, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pokemon.name.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    pokemon.formattedId,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildTypeBadges(pokemon),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileTabs(BuildContext context, Color themeColor) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverTabDelegate(
        TabBar(
          labelColor: Theme.of(context).colorScheme.onSurface,
          unselectedLabelColor: Colors.grey,
          indicatorColor: themeColor,
          indicatorWeight: 4,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(text: 'about'.tr),
            Tab(text: 'base_stats'.tr),
            Tab(text: 'abilities'.tr),
          ],
        ),
        Theme.of(context).colorScheme.surface,
      ),
    );
  }

  // --- SHARED INFO CONTENT (For Desktop) ---
  Widget _buildInfoContent(BuildContext context, PokemonDetailModel pokemon, {bool isDesktop = false}) {
    final themeColor = AppColors.getTypeColor(pokemon.types.first.name);
    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pokemon.name.toUpperCase(),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  pokemon.formattedId,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildTypeBadges(pokemon),
            const SizedBox(height: 35),
            TabBar(
              labelColor: Theme.of(context).colorScheme.onSurface,
              unselectedLabelColor: Colors.grey,
              indicatorColor: themeColor,
              indicatorWeight: 4,
              tabs: [
                Tab(text: 'about'.tr),
                Tab(text: 'base_stats'.tr),
                Tab(text: 'abilities'.tr),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: TabBarView(
                children: [
                  AboutTab(pokemon: pokemon),
                  StatsTab(pokemon: pokemon),
                  AbilitiesTab(pokemon: pokemon),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadges(PokemonDetailModel pokemon) {
    return Wrap(
      spacing: 10,
      children: pokemon.types.map((t) => Chip(
        label: Text(t.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.getTypeColor(t.name),
        side: BorderSide.none,
      )).toList(),
    );
  }
}

// Delegate for the sticky TabBar in mobile
class _SliverTabDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabDelegate(this._tabBar, this._backgroundColor);

  final TabBar _tabBar;
  final Color _backgroundColor;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: _backgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabDelegate oldDelegate) {
    return false;
  }
}
