import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/core/utils/url_helper.dart';

class UserAvatar extends StatefulWidget {
  final VoidCallback onTap;

  const UserAvatar({super.key, required this.onTap});

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar>
    with SingleTickerProviderStateMixin {
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
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated Pulse Aura
          ScaleTransition(
            scale: _pulseAnimation,
            child: Obx(
              () => Container(
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
              ),
            ),
          ),

          // The Animated Avatar
          Obx(
            () => SizedBox(
              width: 65,
              height: 65,
              child: CachedNetworkImage(
                imageUrl: _getAnimatedUrl(SettingsService.to.profileAvatar),
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(strokeWidth: 1),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
            ),
          ),

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
    );
  }

  String _getAnimatedUrl(String staticUrl) {
    try {
      final segments = staticUrl.split('/');
      final idStr = segments.last.split('.').first;
      final id = int.parse(idStr);
      return UrlHelper.getAnimatedGif(id);
    } catch (e) {
      return staticUrl;
    }
  }
}
