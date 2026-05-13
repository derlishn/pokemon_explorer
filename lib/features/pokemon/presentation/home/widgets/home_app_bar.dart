import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
import 'package:pokemon_explorer/routes/app_pages.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/home/widgets/home_search_bar.dart';

class HomeAppBar extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final RxBool isSearching;
  final TextEditingController searchController;
  final VoidCallback onClearSearch;

  const HomeAppBar({
    super.key,
    required this.onSearchChanged,
    required this.isSearching,
    required this.searchController,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 140,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        TranslationKeys.appName.tr,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () => Get.toNamed(AppRoutes.favorites),
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Get.toNamed(AppRoutes.settings),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: HomeSearchBar(
                onChanged: onSearchChanged,
                isSearching: isSearching,
                controller: searchController,
                onClear: onClearSearch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
