import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/features/pokemon/data/models/pokemon_models.dart';

class AbilitiesTab extends StatelessWidget {
  final PokemonDetailModel pokemon;

  const AbilitiesTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(25),
      itemCount: pokemon.abilities.length,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.primary),
          title: Text(
            pokemon.abilities[index].name.capitalizeFirst!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
