import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';

class AboutTab extends StatelessWidget {
  final PokemonDetailModel pokemon;

  const AboutTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(25),
      children: [
        _PokemonInfoRow(
          label: TranslationKeys.height.tr,
          value: '${pokemon.height / 10} ${TranslationKeys.meters.tr}',
          icon: Icons.height,
        ),
        const _InfoDivider(),
        _PokemonInfoRow(
          label: TranslationKeys.weight.tr,
          value: '${pokemon.weight / 10} ${TranslationKeys.kilograms.tr}',
          icon: Icons.monitor_weight,
        ),
        const _InfoDivider(),
        _PokemonInfoRow(
          label: TranslationKeys.baseExperience.tr,
          value: '${pokemon.baseExperience} ${TranslationKeys.xp.tr}',
          icon: Icons.star,
        ),
      ],
    );
  }
}

class _PokemonInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _PokemonInfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 15),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey.withValues(alpha: 0.1),
      height: 1,
    );
  }
}
