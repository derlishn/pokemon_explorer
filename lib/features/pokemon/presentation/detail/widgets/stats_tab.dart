import 'package:flutter/material.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';
import 'package:pokemon_explorer/core/widgets/stat_bar.dart';
import 'package:pokemon_explorer/core/theme/app_colors.dart';

class StatsTab extends StatelessWidget {
  final PokemonDetailModel pokemon;

  const StatsTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final themeColor = AppColors.getTypeColor(pokemon.types.first.name);
    
    return ListView(
      padding: const EdgeInsets.all(25),
      children: pokemon.stats
          .map((s) => StatBar(
                label: s.name,
                value: s.value,
                color: themeColor,
              ))
          .toList(),
    );
  }
}
