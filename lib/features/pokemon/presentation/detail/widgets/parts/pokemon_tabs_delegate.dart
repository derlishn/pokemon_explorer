import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';

class PokemonTabsDelegate extends SliverPersistentHeaderDelegate {
  final Color themeColor;

  PokemonTabsDelegate({required this.themeColor});

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: TabBar(
        labelColor: Theme.of(context).colorScheme.onSurface,
        unselectedLabelColor: Colors.grey,
        indicatorColor: themeColor,
        indicatorWeight: 4,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Tab(text: TranslationKeys.about.tr),
          Tab(text: TranslationKeys.baseStats.tr),
          Tab(text: TranslationKeys.abilities.tr),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant PokemonTabsDelegate oldDelegate) =>
      themeColor != oldDelegate.themeColor;
}
