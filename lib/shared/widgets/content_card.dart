import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Envuelve contenido en una tarjeta con espaciado y estilo compartidos.
class ContentCard extends StatelessWidget {
  const ContentCard({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(padding: const EdgeInsets.all(AppSpace.large), child: child),
  );
}

/// Muestra un aviso accesible con colores semánticos de error o información.
class InlineMessage extends StatelessWidget {
  const InlineMessage({super.key, required this.text, this.error = true});
  final String text;
  final bool error;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpace.medium),
        decoration: BoxDecoration(
          color: error ? scheme.errorContainer : scheme.secondaryContainer,
          borderRadius: BorderRadius.circular(AppSpace.medium),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: error
                ? scheme.onErrorContainer
                : scheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
