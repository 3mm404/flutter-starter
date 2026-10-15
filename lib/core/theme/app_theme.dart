import 'package:flutter/material.dart';

/// Define las paletas; sus nombres conservan las preferencias guardadas.
enum AppPalette {
  ocean('palette.ocean', AppColors.ocean),
  forest('palette.forest', AppColors.forest),
  berry('palette.berry', AppColors.berry),
  violet('palette.violet', AppColors.violet),
  coral('palette.coral', AppColors.coral);

  const AppPalette(this.labelKey, this.seed);
  final String labelKey;
  final Color seed;
}

/// Centraliza acentos vivos, superficies neutras y colores de estado.
abstract final class AppColors {
  static const ink = Color(0xFF172033);
  static const slate = Color(0xFF64748B);
  static const canvas = Color(0xFFF5F7FB);
  static const white = Color(0xFFFFFFFF);
  static const midnight = Color(0xFF0C111B);
  static const ocean = Color(0xFF2563EB);
  static const sky = Color(0xFFDBEAFE);
  static const forest = Color(0xFF047857);
  static const mint = Color(0xFFDCFCE7);
  static const berry = Color(0xFFBE185D);
  static const violet = Color(0xFF7C3AED);
  static const coral = Color(0xFFD94E38);
  static const lavender = Color(0xFFEDE9FE);
  static const amber = Color(0xFF92400E);
  static const sand = Color(0xFFFEF3C7);
  static const danger = Color(0xFFB42318);
  static const successText = Color(0xFF166534);
  static const darkSuccess = Color(0xFF123D2C);
  static const darkSuccessText = Color(0xFFA7F3D0);
  static const darkPending = Color(0xFF472E12);
  static const darkPendingText = Color(0xFFFDE68A);
}

/// Añade colores semánticos para sesiones pendientes o confirmadas.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.pending,
    required this.onPending,
    required this.success,
    required this.onSuccess,
  });
  final Color pending, onPending, success, onSuccess;

  /// Conserva los colores que no se modifican.
  @override
  StatusColors copyWith({
    Color? pending,
    Color? onPending,
    Color? success,
    Color? onSuccess,
  }) => StatusColors(
    pending: pending ?? this.pending,
    onPending: onPending ?? this.onPending,
    success: success ?? this.success,
    onSuccess: onSuccess ?? this.onSuccess,
  );

  /// Anima los colores durante las transiciones de tema.
  @override
  StatusColors lerp(covariant StatusColors? other, double t) => other == null
      ? this
      : StatusColors(
          pending: Color.lerp(pending, other.pending, t)!,
          onPending: Color.lerp(onPending, other.onPending, t)!,
          success: Color.lerp(success, other.success, t)!,
          onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
        );
}

/// Centraliza los espaciados y radios de los componentes.
abstract final class AppSpace {
  static const small = 8.0, medium = 16.0, large = 24.0, xlarge = 32.0;
  static const radius = 20.0;
}

/// Construye temas con acentos vivos y superficies discretas.
abstract final class AppTheme {
  /// Aplica la paleta a formularios, botones, tarjetas y navegación.
  static ThemeData build(AppPalette palette, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: palette.seed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
      surface: dark ? AppColors.midnight : AppColors.white,
    );
    final rounded = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpace.medium),
    );
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpace.medium),
      borderSide: BorderSide(color: scheme.outlineVariant),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: dark ? AppColors.midnight : AppColors.canvas,
      fontFamily: 'sans-serif',
      textTheme: Typography.material2021(platform: TargetPlatform.android).black
          .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface),
      extensions: [
        StatusColors(
          pending: dark ? AppColors.darkPending : AppColors.sand,
          onPending: dark ? AppColors.darkPendingText : AppColors.amber,
          success: dark ? AppColors.darkSuccess : AppColors.mint,
          onSuccess: dark ? AppColors.darkSuccessText : AppColors.successText,
        ),
      ],
      // Distingue el foco de los campos sin usar bordes pesados en reposo.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark
            ? scheme.surfaceContainerLow
            : scheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.all(AppSpace.medium),
        border: inputBorder,
        enabledBorder: inputBorder,
        disabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
        floatingLabelStyle: TextStyle(color: scheme.onSurfaceVariant),
      ),
      // Destaca la acción principal sin añadir sombras pesadas.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 54),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          shape: rounded,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        surfaceTintColor: scheme.surface,
        color: dark ? scheme.surfaceContainerLow : scheme.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpace.radius),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
      ),
      // Unifica los selectores de idioma, apariencia y paleta.
      chipTheme: ChipThemeData(
        backgroundColor: dark ? scheme.surfaceContainer : scheme.surface,
        selectedColor: scheme.primaryContainer,
        labelStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: TextStyle(color: scheme.onPrimaryContainer),
        checkmarkColor: scheme.onPrimaryContainer,
        side: BorderSide(color: scheme.outlineVariant),
        shape: rounded,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      // Identifica el destino activo mediante una cápsula de acento.
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: dark ? scheme.surfaceContainerLow : scheme.surface,
        indicatorColor: scheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.onPrimaryContainer
                : scheme.onSurfaceVariant,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? scheme.onSurface
                : scheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? AppColors.midnight : AppColors.canvas,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: scheme.surface,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
