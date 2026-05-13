import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';
import 'package:pokemon_explorer/core/widgets/empty_state.dart';
import 'package:pokemon_explorer/core/widgets/pokemon_card.dart';
import 'package:pokemon_explorer/core/utils/hero_tags.dart';
import 'package:pokemon_explorer/core/constants/constants.dart';
import 'package:pokemon_explorer/routes/app_pages.dart';

class PokemonPagedGrid extends StatelessWidget {
  final PagingController<int, PokemonListItemModel> pagingController;
  final int crossAxisCount;

  const PokemonPagedGrid({
    super.key,
    required this.pagingController,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: PagedSliverGrid<int, PokemonListItemModel>(
        pagingController: pagingController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        builderDelegate: PagedChildBuilderDelegate<PokemonListItemModel>(
          itemBuilder: (context, item, index) {
            final heroTag = HeroTags.getHomeTag(item.id, index);
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 600),
              columnCount: crossAxisCount,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: PokemonCard(
                    pokemon: item,
                    heroTag: heroTag,
                    onTap: () => Get.toNamed(
                      AppRoutes.detail,
                      arguments: {
                        AppConstants.argPokemon: item,
                        AppConstants.argHeroTag: heroTag,
                      },
                    ),
                  ),
                ),
              ),
            );
          },
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
}
