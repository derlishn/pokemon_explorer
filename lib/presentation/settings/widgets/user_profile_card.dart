import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemon_explorer/services/settings_service.dart';

class UserProfileCard extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;

  const UserProfileCard({
    super.key,
    required this.userName,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: GestureDetector(
        onTap: () => _showAvatarPicker(context),
        child: Obx(() => Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            shape: BoxShape.circle,
            image: DecorationImage(
              image: CachedNetworkImageProvider(SettingsService.to.profileAvatar),
              fit: BoxFit.contain,
            ),
            border: Border.all(color: colorScheme.primary.withOpacity(0.5), width: 2),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 10, color: Colors.white),
                ),
              ),
            ],
          ),
        )),
      ),
      title: Text(
        userName,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text('entrenador_pokemon'.tr),
      trailing: IconButton(
        icon: const Icon(Icons.logout, color: Colors.red),
        onPressed: onLogout,
        tooltip: 'Cerrar Sesión',
      ),
    );
  }

  void _showAvatarPicker(BuildContext context) {
    final avatars = [
      {'name': 'Pikachu', 'id': '25'},
      {'name': 'Bulbasaur', 'id': '1'},
      {'name': 'Charmander', 'id': '4'},
      {'name': 'Squirtle', 'id': '7'},
      {'name': 'Eevee', 'id': '133'},
    ];

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Elige tu compañero',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: avatars.length,
                separatorBuilder: (_, __) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  final id = avatars[index]['id']!;
                  final url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
                  
                  return GestureDetector(
                    onTap: () {
                      SettingsService.to.updateAvatar(url);
                      Get.back();
                    },
                    child: Column(
                      children: [
                        Obx(() {
                          final isSelected = SettingsService.to.profileAvatar == url;
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? Theme.of(context).colorScheme.primaryContainer 
                                  : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                              border: isSelected 
                                  ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
                                  : null,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.contain,
                            ),
                          );
                        }),
                        const SizedBox(height: 5),
                        Text(avatars[index]['name']!, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
