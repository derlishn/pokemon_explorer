import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
import 'package:pokemon_explorer/services/settings_service.dart';
import 'package:pokemon_explorer/core/widgets/app_snackbar.dart';

class StorageSection extends StatelessWidget {
  const StorageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCacheToggle(context),
        _buildClearCacheButton(context),
      ],
    );
  }

  Widget _buildCacheToggle(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.cached),
      title: Text(TranslationKeys.useCacheTitle.tr),
      subtitle: Text(
        TranslationKeys.useCacheDesc.tr,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Obx(() => Switch.adaptive(
            value: SettingsService.to.useCache,
            onChanged: (val) {
              if (!val) {
                _showCacheWarning(context);
              } else {
                SettingsService.to.updateUseCache(true);
              }
            },
          )),
    );
  }

  Widget _buildClearCacheButton(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
      title: Text(TranslationKeys.clearCacheTitle.tr),
      subtitle: Text(
        TranslationKeys.clearCacheDesc.tr,
        style: const TextStyle(fontSize: 12),
      ),
      onTap: () => _showClearCacheConfirm(context),
    );
  }

  void _showCacheWarning(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 10),
            Text(TranslationKeys.cacheWarningTitle.tr),
          ],
        ),
        content: Text(TranslationKeys.cacheWarningMsg.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(TranslationKeys.cancel.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
            onPressed: () {
              SettingsService.to.updateUseCache(false);
              Get.back();
            },
            child: Text(TranslationKeys.disable.tr),
          ),
        ],
      ),
    );
  }

  void _showClearCacheConfirm(BuildContext context) {
    final count = SettingsService.to.getCachedCount();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(TranslationKeys.clearCacheConfirmTitle.tr),
        content: Text(
          TranslationKeys.clearCacheConfirmMsg.tr
              .replaceFirst('@count', count.toString()),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(TranslationKeys.cancel.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              SettingsService.to.clearCache();
              Get.back();
              AppSnackbar.success(
                title: TranslationKeys.cacheClearedTitle.tr,
                message: TranslationKeys.cacheClearedMsg.tr,
              );
            },
            child: Text(TranslationKeys.delete.tr),
          ),
        ],
      ),
    );
  }
}
