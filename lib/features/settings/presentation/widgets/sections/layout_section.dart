import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
import 'package:pokemon_explorer/services/settings_service.dart';

class LayoutSection extends StatelessWidget {
  const LayoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final allowedValues = [0, 1, 2];
      final int currentValue = SettingsService.to.gridColumns;

      if (!allowedValues.contains(currentValue)) {
        return const SizedBox.shrink();
      }

      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.grid_view),
        title: Text(TranslationKeys.gridColumns.tr),
        subtitle: Text(
          currentValue == 0
              ? TranslationKeys.auto.tr
              : '$currentValue ${TranslationKeys.gridColumns.tr.split(' ').last}',
        ),
        trailing: DropdownButton<int>(
          value: currentValue,
          underline: const SizedBox(),
          items: [
            DropdownMenuItem(value: 0, child: Text(TranslationKeys.auto.tr)),
            const DropdownMenuItem(value: 1, child: Text('1')),
            const DropdownMenuItem(value: 2, child: Text('2')),
          ],
          onChanged: (val) => SettingsService.to.updateGridColumns(val!),
        ),
      );
    });
  }
}
