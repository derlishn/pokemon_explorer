import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/detail/widgets/about_tab.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/detail/widgets/stats_tab.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/detail/widgets/abilities_tab.dart';

class PokemonDetailTabs extends StatelessWidget {
  final PokemonDetailModel pokemon;
  final Color themeColor;

  const PokemonDetailTabs({
    super.key,
    required this.pokemon,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
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
        const SizedBox(height: 20),
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
    );
  }
}
