import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemon_explorer/data/models/pokemon_detail_model.dart';
import 'package:pokemon_explorer/helpers/app_colors.dart';
import 'package:pokemon_explorer/presentation/layouts/adaptive_layout.dart';
import 'package:pokemon_explorer/services/favorites_service.dart';
import 'detail_controller.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.obx(
        (state) => AdaptiveLayout(
          mobile: _buildMobileLayout(context, state!),
          desktop: _buildDesktopLayout(context, state!),
        ),
        onLoading: const Center(child: CircularProgressIndicator()),
        onError: (error) => Center(child: Text(error ?? 'Error')),
      ),
    );
  }

  // --- DESKTOP LAYOUT (Split View) ---
  Widget _buildDesktopLayout(BuildContext context, PokemonDetailModel pokemon) {
    final themeColor = AppColors.getTypeColor(pokemon.types.first.name);
    
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            color: themeColor,
            child: Stack(
              children: [
                _buildRotatingPokeball(context, size: 600, opacity: 0.1),
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
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: _buildInfoContent(context, pokemon, isDesktop: true),
          ),
        ),
      ],
    );
  }

  // --- MOBILE LAYOUT (NestedScrollView) ---
  Widget _buildMobileLayout(BuildContext context, PokemonDetailModel pokemon) {
    final themeColor = AppColors.getTypeColor(pokemon.types.first.name);

    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: themeColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  _buildRotatingPokeball(context, size: 300, opacity: 0.2),
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
          ),
          SliverToBoxAdapter(
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
          ),
          SliverPersistentHeader(
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
          ),
        ],
        body: Container(
          color: Theme.of(context).colorScheme.surface,
          child: TabBarView(
            children: [
              _buildAboutTab(context, pokemon),
              _buildStatsTab(context, pokemon),
              _buildAbilitiesTab(context, pokemon),
            ],
          ),
        ),
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
                  _buildAboutTab(context, pokemon),
                  _buildStatsTab(context, pokemon),
                  _buildAbilitiesTab(context, pokemon),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TABS CONTENT ---
  Widget _buildAboutTab(BuildContext context, PokemonDetailModel pokemon) {
    return ListView(
      padding: const EdgeInsets.all(25),
      children: [
        _buildInfoRow('height'.tr, '${pokemon.height / 10} m', Icons.height),
        _buildDivider(),
        _buildInfoRow('weight'.tr, '${pokemon.weight / 10} kg', Icons.monitor_weight),
      ],
    );
  }

  Widget _buildStatsTab(BuildContext context, PokemonDetailModel pokemon) {
    final themeColor = AppColors.getTypeColor(pokemon.types.first.name);
    return ListView(
      padding: const EdgeInsets.all(25),
      children: pokemon.stats
          .map((s) => _buildStatBar(context, s.name, s.value, themeColor))
          .toList(),
    );
  }

  Widget _buildAbilitiesTab(BuildContext context, PokemonDetailModel pokemon) {
    return ListView.builder(
      padding: const EdgeInsets.all(25),
      itemCount: pokemon.abilities.length,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
        child: ListTile(
          leading: const Icon(Icons.bolt),
          title: Text(pokemon.abilities[index].name.capitalizeFirst!),
        ),
      ),
    );
  }

  // --- UTILS ---
  Widget _buildRotatingPokeball(BuildContext context, {required double size, required double opacity}) {
    return Positioned(
      right: -size / 4,
      top: -size / 4,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 2 * 3.14159),
        duration: const Duration(seconds: 20),
        builder: (context, double value, child) {
          return Transform.rotate(
            angle: value,
            child: Icon(Icons.catching_pokemon, size: size, color: Colors.white.withOpacity(opacity)),
          );
        },
      ),
    );
  }

  Widget _buildStatBar(BuildContext context, String label, int value, Color color) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label.toUpperCase(), style: TextStyle(color: onSurface.withOpacity(0.5), fontSize: 12))),
          SizedBox(width: 40, child: Text('$value', style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 150,
              backgroundColor: color.withOpacity(0.1),
              color: color,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
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

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 15),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(color: Colors.grey.withOpacity(0.1), height: 1);
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
