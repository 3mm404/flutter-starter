import 'package:app_1/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double contrast(Color foreground, Color background) {
  final a = foreground.computeLuminance();
  final b = background.computeLuminance();
  return a > b ? (a + 0.05) / (b + 0.05) : (b + 0.05) / (a + 0.05);
}

void main() {
  for (final palette in AppPalette.values) {
    for (final brightness in Brightness.values) {
      test(
        [palette.name, brightness.name, 'text remains readable'].join(' '),
        () {
          final theme = AppTheme.build(palette, brightness);
          final colors = theme.colorScheme;
          final status = theme.extension<StatusColors>()!;
          final pairs = <String, (Color, Color)>{
            'body': (colors.onSurface, colors.surface),
            'background': (colors.onSurface, theme.scaffoldBackgroundColor),
            'card': (colors.onSurface, theme.cardTheme.color!),
            'button': (colors.onPrimary, colors.primary),
            'selected chip': (
              colors.onPrimaryContainer,
              colors.primaryContainer,
            ),
            'home header start': (
              colors.onPrimaryContainer,
              colors.primaryContainer,
            ),
            'home header end': (
              colors.onPrimaryContainer,
              colors.secondaryContainer,
            ),
            'error': (colors.onErrorContainer, colors.errorContainer),
            'pending': (status.onPending, status.pending),
            'success': (status.onSuccess, status.success),
            'secondary text': (colors.onSurfaceVariant, colors.surface),
          };
          for (final entry in pairs.entries) {
            expect(
              contrast(entry.value.$1, entry.value.$2),
              greaterThanOrEqualTo(4.5),
              reason: entry.key,
            );
          }
        },
      );
    }
  }
}
