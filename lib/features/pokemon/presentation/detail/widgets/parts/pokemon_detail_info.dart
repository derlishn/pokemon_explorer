import 'package:flutter/material.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/detail/widgets/parts/pokemon_type_badge.dart';

class PokemonDetailInfo extends StatelessWidget {
  final PokemonDetailModel pokemon;
  final bool isDesktop;

  const PokemonDetailInfo({
    super.key,
    required this.pokemon,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              pokemon.name.toUpperCase(),
              style: (isDesktop ? textTheme.displaySmall : textTheme.headlineMedium)
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              pokemon.formattedId,
              style: (isDesktop ? textTheme.headlineSmall : textTheme.titleLarge)
                  ?.copyWith(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 10),
        PokemonTypeBadge(types: pokemon.types),
      ],
    );
  }
}
