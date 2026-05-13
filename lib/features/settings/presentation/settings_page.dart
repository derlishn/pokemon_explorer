import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_explorer/core/constants/translation_keys.dart';
import 'package:pokemon_explorer/core/widgets/section_header.dart';
import 'package:pokemon_explorer/features/settings/presentation/widgets/user_profile_card.dart';
import 'package:pokemon_explorer/features/settings/presentation/widgets/about_app_card.dart';
import 'package:pokemon_explorer/core/layouts/adaptive_layout.dart';
import 'package:pokemon_explorer/features/settings/presentation/settings_controller.dart';
import 'package:pokemon_explorer/features/settings/presentation/widgets/sections/theme_section.dart';
import 'package:pokemon_explorer/features/settings/presentation/widgets/sections/storage_section.dart';
import 'package:pokemon_explorer/features/settings/presentation/widgets/sections/layout_section.dart';
import 'package:pokemon_explorer/features/settings/presentation/widgets/sections/language_section.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TranslationKeys.settings.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: AdaptiveLayout(
        mobile: _buildMobileLayout(),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
      children: [
        SectionHeader(title: TranslationKeys.user.tr),
        Obx(() => UserProfileCard(
              userName: controller.userName,
              onLogout: () => controller.logout(),
            )),
        const Divider(),
        SectionHeader(title: TranslationKeys.theme.tr),
        const ThemeSection(),
        const Divider(),
        SectionHeader(title: TranslationKeys.storage.tr),
        const StorageSection(),
        const Divider(),
        SectionHeader(title: TranslationKeys.layout.tr),
        const LayoutSection(),
        const Divider(),
        SectionHeader(title: TranslationKeys.language.tr),
        const LanguageSection(),
        const Divider(),
        SectionHeader(title: TranslationKeys.aboutApp.tr),
        const AboutAppCard(),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Obx(() => UserProfileCard(
                    userName: controller.userName,
                    onLogout: () => controller.logout(),
                  )),
              const SizedBox(height: 32),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _buildDesktopBox(TranslationKeys.theme.tr, const ThemeSection()),
                  _buildDesktopBox(TranslationKeys.storage.tr, const StorageSection()),
                  _buildDesktopBox(TranslationKeys.layout.tr, const LayoutSection()),
                  _buildDesktopBox(TranslationKeys.language.tr, const LanguageSection()),
                ],
              ),
              const SizedBox(height: 48),
              const AboutAppCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopBox(String title, Widget content) {
    return Container(
      width: 450,
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.primary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }
}
