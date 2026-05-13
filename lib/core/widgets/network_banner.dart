import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
import 'package:pokemon_explorer/services/connectivity_service.dart';

class NetworkBanner extends GetView<ConnectivityService> {
  const NetworkBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isConnected = controller.isConnected;
      
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isConnected ? 0 : 40,
        width: double.infinity,
        color: Theme.of(context).colorScheme.errorContainer,
        child: isConnected 
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${TranslationKeys.noConnectionTitle.tr} - ${TranslationKeys.loadingLocalData.tr}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      // In Home Controller we have auto-retry, 
                      // but manual retry button is good.
                      Get.snackbar(
                        TranslationKeys.retry.tr,
                        TranslationKeys.checkInternetConnection.tr,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Theme.of(context).colorScheme.error,
                        colorText: Theme.of(context).colorScheme.onError,
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      TranslationKeys.retry.tr,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      );
    });
  }
}
