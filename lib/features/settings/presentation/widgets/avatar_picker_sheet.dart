import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
import 'package:pokemon_explorer/core/config/avatar_config.dart';

class AvatarPickerSheet extends StatelessWidget {
  const AvatarPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    const avatars = AvatarConfig.availableAvatars;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            TranslationKeys.choosePartner.tr,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: avatars.length,
              separatorBuilder: (context, index) => const SizedBox(width: 15),
              itemBuilder: (context, index) {
                final avatar = avatars[index];

                return GestureDetector(
                  onTap: () {
                    SettingsService.to.updateAvatar(avatar.staticUrl);
                    Get.back();
                  },
                  child: Column(
                    children: [
                      Obx(() {
                        final isSelected =
                            SettingsService.to.profileAvatar == avatar.staticUrl;
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest
                                    .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? Border.all(
                                    color: SettingsService.to.accentColor,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: avatar.animatedUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 1),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 5),
                      Text(
                        avatar.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
