import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/home/home_controller.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/home/widgets/home_app_bar.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/home/widgets/pokemon_paged_grid.dart';
import 'package:pokemon_explorer/core/widgets/network_banner.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const NetworkBanner(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Adaptive Columns Calculation
                  final double width = constraints.maxWidth;
                  final int manualColumns = SettingsService.to.gridColumns;
                  final int crossAxisCount = manualColumns > 0
                      ? manualColumns
                      : (width > 1200 ? 6 : (width > 600 ? 4 : 2));

                  return CustomScrollView(
                    slivers: [
                      HomeAppBar(
                        onSearchChanged: (val) => controller.search = val,
                        isSearching: controller.isSearching,
                        searchController: controller.searchController,
                        onClearSearch: controller.clearSearch,
                      ),
                      PokemonPagedGrid(
                        pagingController: controller.pagingController,
                        crossAxisCount: crossAxisCount,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
