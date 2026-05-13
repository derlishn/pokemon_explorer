import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/data/models/pokemon_detail_model.dart';

class AboutTab extends StatelessWidget {
  final PokemonDetailModel pokemon;

  const AboutTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(25),
      children: [
        _buildInfoRow('height'.tr, '${pokemon.height / 10} m', Icons.height),
        _buildDivider(),
        _buildInfoRow('weight'.tr, '${pokemon.weight / 10} kg', Icons.monitor_weight),
        _buildDivider(),
        _buildInfoRow('base_experience'.tr, '${pokemon.baseExperience} xp', Icons.star),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 15),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(color: Colors.grey.withValues(alpha: 0.1), height: 1);
}
