import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/localization/app_translations.dart';
import '../../../../core/settings/settings_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/content_card.dart';

/// Permite cambiar idioma, apariencia y paleta dentro de Home.
class PreferencesPanel extends GetView<SettingsController> {
  const PreferencesPanel({super.key});
  @override
  Widget build(BuildContext context) => ContentCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('settings'.tr, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpace.small),
        Text('settings.subtitle'.tr),
        const SizedBox(height: AppSpace.large),
        Text(
          'settings.language'.tr,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: AppSpace.small),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < AppTranslations.languages.length; i++)
                ChoiceChip(
                  label: Text(AppTranslations.nativeNames[i]),
                  selected:
                      controller.language.value == AppTranslations.languages[i],
                  onSelected: (_) =>
                      controller.setLanguage(AppTranslations.languages[i]),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.large),
        Text(
          'settings.theme'.tr,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: AppSpace.small),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final mode in ThemeMode.values)
                ChoiceChip(
                  label: Text(('theme.${mode.name}').tr),
                  selected: controller.mode.value == mode,
                  onSelected: (_) => controller.setMode(mode),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.large),
        Text(
          'settings.palette'.tr,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: AppSpace.small),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final palette in AppPalette.values)
                ChoiceChip(
                  label: Text(palette.labelKey.tr),
                  avatar: Icon(Icons.circle, color: palette.seed, size: 16),
                  selected: controller.palette.value == palette,
                  onSelected: (_) => controller.setPalette(palette),
                ),
            ],
          ),
        ),
        Obx(
          () => controller.errorKey.value == null
              ? const SizedBox.shrink()
              : InlineMessage(text: controller.errorKey.value!.tr),
        ),
      ],
    ),
  );
}
