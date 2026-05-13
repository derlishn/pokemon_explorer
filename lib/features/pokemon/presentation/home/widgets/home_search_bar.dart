import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';

class HomeSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final RxBool isSearching;
  final TextEditingController controller;
  final VoidCallback onClear;

  const HomeSearchBar({
    super.key,
    required this.onChanged,
    required this.isSearching,
    required this.controller,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: TranslationKeys.searchHint.tr,
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: Obx(() {
            if (isSearching.value) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: colorScheme.primary,
                  size: 24,
                ),
              );
            }

            if (controller.text.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: onClear,
              );
            }

            return const SizedBox.shrink();
          }),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
