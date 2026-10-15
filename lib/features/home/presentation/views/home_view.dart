import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/settings/settings_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/content_card.dart';
import '../../../auth/presentation/controllers/session_controller.dart';
import '../controllers/home_controller.dart';
import '../widgets/preferences_panel.dart';

/// Contiene Home, la barra de cuatro destinos y la acción de cerrar sesión.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  /// Mantiene las etiquetas en el mismo orden que los índices e iconos de navegación.
  static const labels = ['nav.home', 'nav.two', 'nav.three', 'nav.four'];
  static const icons = [
    Icons.home_outlined,
    Icons.grid_view_outlined,
    Icons.bookmark_border,
    Icons.layers_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final session = Get.find<SessionController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('app.name'.tr),
        actions: [
          IconButton(
            key: const Key('logout'),
            onPressed: () => session.logout(),
            tooltip: 'logout'.tr,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(
        // Conserva las vistas y su estado mientras cambia el destino seleccionado.
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: [
            const _HomeContent(),
            for (var i = 1; i < 4; i++) _Placeholder(number: i + 1),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        // Muestra los cuatro botones y comunica su índice al controlador.
        () => NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.select,
          destinations: [
            for (var i = 0; i < 4; i++)
              NavigationDestination(icon: Icon(icons[i]), label: labels[i].tr),
          ],
        ),
      ),
    );
  }
}

/// Muestra el saludo, el perfil, el estado de sesión y las preferencias.
class _HomeContent extends StatelessWidget {
  const _HomeContent();
  @override
  Widget build(BuildContext context) {
    final session = Get.find<SessionController>();
    final settings = Get.find<SettingsController>();
    return Obx(() {
      final user = session.user.value;
      if (user == null) return const SizedBox.shrink();
      final locale = settings.language.value;
      final scheme = Theme.of(context).colorScheme;
      final statuses = Theme.of(context).extension<StatusColors>()!;
      final count = user.roles.length;
      final roleCount = (count == 1 ? 'role.one' : 'role.many').trParams({
        'count': NumberFormat.decimalPattern(locale).format(count),
      });
      return SingleChildScrollView(
        key: const PageStorageKey('home-scroll'),
        padding: const EdgeInsets.all(AppSpace.large),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpace.large),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpace.radius),
                    gradient: LinearGradient(
                      colors: [
                        scheme.primaryContainer,
                        scheme.secondaryContainer,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.waving_hand_outlined,
                        color: scheme.onPrimaryContainer,
                        size: 32,
                      ),
                      const SizedBox(height: AppSpace.medium),
                      Text(
                        'home.greeting'.trParams({'name': user.name}),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: scheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppSpace.small),
                      Text(
                        'home.subtitle'.tr,
                        style: TextStyle(color: scheme.onPrimaryContainer),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpace.medium),
                if (session.confirmed.value)
                  Container(
                    padding: const EdgeInsets.all(AppSpace.medium),
                    decoration: BoxDecoration(
                      color: statuses.success,
                      borderRadius: BorderRadius.circular(AppSpace.medium),
                    ),
                    child: Text(
                      'session.confirmed'.tr,
                      style: TextStyle(color: statuses.onSuccess),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(AppSpace.medium),
                    decoration: BoxDecoration(
                      color: statuses.pending,
                      borderRadius: BorderRadius.circular(AppSpace.medium),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'session.pending'.tr,
                          style: TextStyle(color: statuses.onPending),
                        ),
                        TextButton(
                          onPressed: session.restoring.value
                              ? null
                              : session.restore,
                          child: Text('session.retry'.tr),
                        ),
                      ],
                    ),
                  ),
                if (session.errorKey.value != null) ...[
                  const SizedBox(height: AppSpace.small),
                  InlineMessage(text: session.errorKey.value!.tr),
                ],
                const SizedBox(height: AppSpace.large),
                ContentCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'home.profile'.tr,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpace.medium),
                      _ProfileRow(
                        icon: Icons.email_outlined,
                        label: 'email'.tr,
                        value: user.email,
                      ),
                      _ProfileRow(
                        icon: Icons.cake_outlined,
                        label: 'profile.birth'.tr,
                        value: user.dateOfBirth == null
                            ? 'profile.empty'.tr
                            : DateFormat.yMMMMd(locale)
                                  .format(user.dateOfBirth!),
                      ),
                      _ProfileRow(
                        icon: Icons.badge_outlined,
                        label: 'profile.roles'.tr,
                        value: roleCount,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpace.large),
                const PreferencesPanel(),
              ],
            ),
          ),
        ),
      );
    });
  }
}

/// Presenta un dato del perfil con su icono, etiqueta y valor.
class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpace.small),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: AppSpace.medium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              SelectableText(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Identifica una sección provisional sin agregar funcionalidades de negocio.
class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.number});
  final int number;
  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpace.large),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: ContentCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.construction_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppSpace.medium),
              Text(
                'placeholder.title'.tr,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpace.small),
              Text(
                'placeholder.body'.trParams({
                  'number': NumberFormat.decimalPattern(
                    Get.locale?.languageCode ?? 'es',
                  ).format(number),
                }),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
