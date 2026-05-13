import 'package:flutter/material.dart';
import 'package:pokemon_explorer/core/theme/app_colors.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';

class PokemonTypeBadge extends StatelessWidget {
  final List<PokemonTypeModel> types;

  const PokemonTypeBadge({super.key, required this.types});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: types
          .map((t) => Chip(
                label: Text(
                  t.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: AppColors.getTypeColor(t.name),
                side: BorderSide.none,
              ))
          .toList(),
    );
  }
}
