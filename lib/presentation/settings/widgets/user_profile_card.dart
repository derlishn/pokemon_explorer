import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/helpers/api_constants.dart';

class UserProfileCard extends StatefulWidget {
  final String userName;
  final VoidCallback onLogout;

  const UserProfileCard({
    super.key,
    required this.userName,
    required this.onLogout,
  });

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: () => _showAvatarPicker(context),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animated Pulse Aura
            ScaleTransition(
              scale: _pulseAnimation,
              child: Obx(() => Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: SettingsService.to.accentColor.withValues(alpha: 0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              )),
            ),
            
            // The Animated Avatar
            Obx(() => SizedBox(
              width: 65,
              height: 65,
              child: CachedNetworkImage(
                imageUrl: _getAnimatedUrl(SettingsService.to.profileAvatar),
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 1))),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
            )),
            
            // Edit Badge
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: SettingsService.to.accentColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 10, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      title: Text(
        widget.userName,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text('entrenador_pokemon'.tr),
      trailing: IconButton(
        icon: const Icon(Icons.logout, color: Colors.red),
        onPressed: widget.onLogout,
      ),
    );
  }

  String _getAnimatedUrl(String staticUrl) {
    try {
      final segments = staticUrl.split('/');
      final idStr = segments.last.split('.').first;
      final id = int.parse(idStr);
      return ApiConstants.animatedGifUrl(id);
    } catch (e) {
      return staticUrl;
    }
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
              'Elige tu compañero animado',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: avatars.length,
                separatorBuilder: (context, index) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  final id = avatars[index]['id']!;
                  final staticUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
                  final animatedUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/$id.gif';
                  
                  return GestureDetector(
                    onTap: () {
                      SettingsService.to.updateAvatar(staticUrl);
                      Get.back();
                    },
                    child: Column(
                      children: [
                        Obx(() {
                          final isSelected = SettingsService.to.profileAvatar == staticUrl;
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? Theme.of(context).colorScheme.primaryContainer 
                                  : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                              border: isSelected 
                                  ? Border.all(color: SettingsService.to.accentColor, width: 2)
                                  : null,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: animatedUrl,
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
