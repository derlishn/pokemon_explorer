import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';
import 'package:pokemon_explorer/core/theme/app_colors.dart';
import 'package:pokemon_explorer/core/layouts/adaptive_layout.dart';
import 'package:pokemon_explorer/core/widgets/rotating_pokeball.dart';
import 'package:pokemon_explorer/core/widgets/favorite_button.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/detail/detail_controller.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/detail/widgets/about_tab.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/detail/widgets/stats_tab.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/detail/widgets/abilities_tab.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/detail/widgets/parts/detail_app_bar.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/detail/widgets/parts/pokemon_detail_info.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/detail/widgets/parts/pokemon_detail_tabs.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/detail/widgets/parts/pokemon_tabs_delegate.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use initial data to show Name/Image immediately
    final initialPokemon = controller.initialData;
    final placeholderDetail = PokemonDetailModel.fromListItem(initialPokemon);

    return Scaffold(
      body: AdaptiveLayout(
        mobile: _MobileDetail(
          initialPokemon: initialPokemon,
          placeholderDetail: placeholderDetail,
        ),
        desktop: _DesktopDetail(
          initialPokemon: initialPokemon,
          placeholderDetail: placeholderDetail,
        ),
      ),
    );
  }
}

class _MobileDetail extends GetView<DetailController> {
  final PokemonListItemModel initialPokemon;
  final PokemonDetailModel placeholderDetail;

  const _MobileDetail({
    required this.initialPokemon,
    required this.placeholderDetail,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = AppColors.getTypeColor(initialPokemon.types.first);

    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          DetailAppBar(
            pokemon: placeholderDetail,
            themeColor: themeColor,
            heroTag: controller.heroTag,
          ),
          _MobileTitleSection(pokemon: placeholderDetail),
          SliverPersistentHeader(
            pinned: true,
            delegate: PokemonTabsDelegate(themeColor: themeColor),
          ),
        ],
        body: controller.obx(
          (state) => TabBarView(
            children: [
              AboutTab(pokemon: state!),
              StatsTab(pokemon: state),
              AbilitiesTab(pokemon: state),
            ],
          ),
          onLoading: const Center(child: CircularProgressIndicator()),
          onError: (error) => Center(child: Text(error ?? '')),
        ),
      ),
    );
  }
}

class _MobileTitleSection extends StatelessWidget {
  final PokemonDetailModel pokemon;
  const _MobileTitleSection({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        transform: Matrix4.translationValues(0, -30, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 45, 25, 0),
          child: PokemonDetailInfo(pokemon: pokemon),
        ),
      ),
    );
  }
}

class _DesktopDetail extends GetView<DetailController> {
  final PokemonListItemModel initialPokemon;
  final PokemonDetailModel placeholderDetail;

  const _DesktopDetail({
    required this.initialPokemon,
    required this.placeholderDetail,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = AppColors.getTypeColor(initialPokemon.types.first);

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: _DesktopHeroSection(
            pokemon: placeholderDetail,
            themeColor: themeColor,
            heroTag: controller.heroTag,
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  PokemonDetailInfo(pokemon: placeholderDetail, isDesktop: true),
                  const SizedBox(height: 35),
                  Expanded(
                    child: controller.obx(
                      (state) => PokemonDetailTabs(
                        pokemon: state!,
                        themeColor: themeColor,
                      ),
                      onLoading: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DesktopHeroSection extends StatelessWidget {
  final PokemonDetailModel pokemon;
  final Color themeColor;
  final String heroTag;

  const _DesktopHeroSection({
    required this.pokemon,
    required this.themeColor,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeColor,
      child: Stack(
        children: [
          const RotatingPokeball(size: 600, opacity: 0.1),
          Center(
            child: Hero(
              tag: heroTag,
              child: Image.network(
                pokemon.imageUrl,
                width: 450,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 40,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Get.back(),
            ),
          ),
          Positioned(
            top: 40,
            right: 40,
            child: FavoriteButton(
              pokemonId: pokemon.id,
              pokemonData: pokemon,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}
