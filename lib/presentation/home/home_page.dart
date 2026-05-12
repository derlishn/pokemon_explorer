import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pokemon_explorer/data/models/pokemon_list_model.dart';
import 'package:pokemon_explorer/services/auth_service.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final int crossAxisCount = width > 1200 ? 6 : (width > 600 ? 4 : 2);

    return Scaffold(
      body: CustomScrollView(
        // Rígido para evitar estiramientos al vacío
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'home'.tr,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: () => AuthService.to.logout(),
              ),
            ],
          ),
          
          // Usamos un Builder para decidir si mostrar el Grid o el Cargador de pantalla completa
          // Esto evita que el usuario haga scroll hacia el "vacío" mientras no hay datos.
          PagedSliverGrid<int, PokemonListItemModel>(
            pagingController: controller.pagingController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            builderDelegate: PagedChildBuilderDelegate<PokemonListItemModel>(
              itemBuilder: (context, item, index) => AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 600),
                columnCount: crossAxisCount,
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildPokemonCard(context, item),
                  ),
                ),
              ),
              // IMPORTANTE: El cargador de la primera página no permite scroll
              // Ocupa todo el espacio restante de la pantalla.
              firstPageProgressIndicatorBuilder: (context) => _buildFullScreenLoading(context, crossAxisCount),
              newPageProgressIndicatorBuilder: (_) => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Crea una estructura que llena la pantalla y evita el scroll al vacío
  Widget _buildFullScreenLoading(BuildContext context, int crossAxisCount) {
    return Container(
      // Forzamos que ocupe al menos la altura de la pantalla menos el AppBar
      height: MediaQuery.of(context).size.height - 150,
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(), // Bloqueamos scroll interno
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: 8, // Suficientes para llenar la pantalla inicial
        itemBuilder: (context, index) => _buildSkeletonCard(context),
      ),
    );
  }

  Widget _buildSkeletonCard(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3);
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Icon(Icons.catching_pokemon, size: 60, color: color.withOpacity(0.5)),
            ),
          ),
          Container(
            height: 25,
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPokemonCard(BuildContext context, PokemonListItemModel pokemon) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: () => Get.toNamed('/detail', arguments: pokemon),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Icon(
                      Icons.catching_pokemon,
                      size: 100,
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  Center(
                    child: Hero(
                      tag: 'pokemon_${pokemon.id}',
                      child: CachedNetworkImage(
                        imageUrl: pokemon.imageUrl,
                        height: 120,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
              ),
              child: Text(
                pokemon.name.capitalizeFirst!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
