import 'package:flutter/material.dart';

/// Paleta completa de wereat, extraída de design/wereat-design-system.html.
/// Coral: marca, CTA, comida. Teal: mapa/ubicación. Ámbar: categorías.
/// Gris cálido: texto y superficies.
class AppColors {
  const AppColors._();

  static const Color coral50 = Color(0xFFFAECE7);
  static const Color coral100 = Color(0xFFF5C4B3);
  static const Color coral200 = Color(0xFFF0997B);
  static const Color coral400 = Color(0xFFD85A30);
  static const Color coral600 = Color(0xFF993C1D);
  static const Color coral800 = Color(0xFF712B13);
  static const Color coral900 = Color(0xFF4A1B0C);

  static const Color teal50 = Color(0xFFE1F5EE);
  static const Color teal100 = Color(0xFF9FE1CB);
  static const Color teal200 = Color(0xFF5DCAA5);
  static const Color teal400 = Color(0xFF1D9E75);
  static const Color teal600 = Color(0xFF0F6E56);
  static const Color teal800 = Color(0xFF085041);
  static const Color teal900 = Color(0xFF04342C);

  static const Color amber50 = Color(0xFFFAEEDA);
  static const Color amber100 = Color(0xFFFAC775);
  static const Color amber200 = Color(0xFFEF9F27);
  static const Color amber400 = Color(0xFFBA7517);
  static const Color amber600 = Color(0xFF854F0B);
  static const Color amber800 = Color(0xFF633806);
  static const Color amber900 = Color(0xFF412402);

  static const Color gray50 = Color(0xFFF1EFE8);
  static const Color gray100 = Color(0xFFD3D1C7);
  static const Color gray200 = Color(0xFFB4B2A9);
  static const Color gray400 = Color(0xFF888780);
  static const Color gray600 = Color(0xFF5F5E5A);
  static const Color gray800 = Color(0xFF444441);
  static const Color gray900 = Color(0xFF2C2C2A);
  static const Color gray950 = Color(0xFF17160F);

  static const Color cream = Color(0xFFFBF9F4);

  /// Superficie de card sobre fondo oscuro (gray950).
  static const Color surfaceDark = Color(0xFF211F19);
}

/// Acceso a la paleta completa vía Theme.of(context).extension&lt;AppColorsExtension&gt;()
/// para los tonos que ColorScheme no modela (teal, ámbar, ramps completas).
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.teal,
    required this.amber,
    required this.cream,
  });

  final Color teal;
  final Color amber;
  final Color cream;

  static const light = AppColorsExtension(
    teal: AppColors.teal600,
    amber: AppColors.amber200,
    cream: AppColors.cream,
  );

  @override
  AppColorsExtension copyWith({Color? teal, Color? amber, Color? cream}) {
    return AppColorsExtension(
      teal: teal ?? this.teal,
      amber: amber ?? this.amber,
      cream: cream ?? this.cream,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      teal: Color.lerp(teal, other.teal, t)!,
      amber: Color.lerp(amber, other.amber, t)!,
      cream: Color.lerp(cream, other.cream, t)!,
    );
  }
}
