import 'package:flutter/material.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/features/map/domain/entities/place.dart';

/// Estilo visual por categoría, usado en badges, chips de filtro y pines del
/// mapa para que la misma categoría siempre se vea igual en toda la app.
extension PlaceCategoryStyle on PlaceCategory {
  String get label => switch (this) {
    PlaceCategory.restaurant => 'Restaurante',
    PlaceCategory.cafe => 'Cafetería',
    PlaceCategory.bar => 'Bar',
  };

  String get pluralLabel => switch (this) {
    PlaceCategory.restaurant => 'Restaurantes',
    PlaceCategory.cafe => 'Cafeterías',
    PlaceCategory.bar => 'Bares',
  };

  IconData get icon => switch (this) {
    PlaceCategory.restaurant => Icons.restaurant,
    PlaceCategory.cafe => Icons.coffee,
    PlaceCategory.bar => Icons.local_bar,
  };

  /// Color sólido: pines del mapa, chip seleccionado.
  Color get accent => switch (this) {
    PlaceCategory.restaurant => AppColors.coral400,
    PlaceCategory.cafe => AppColors.amber400,
    PlaceCategory.bar => AppColors.teal600,
  };

  /// Fondo suave: badges, chip sin seleccionar.
  Color get background => switch (this) {
    PlaceCategory.restaurant => AppColors.coral50,
    PlaceCategory.cafe => AppColors.amber50,
    PlaceCategory.bar => AppColors.teal50,
  };

  /// Texto/ícono sobre [background].
  Color get foreground => switch (this) {
    PlaceCategory.restaurant => AppColors.coral600,
    PlaceCategory.cafe => AppColors.amber600,
    PlaceCategory.bar => AppColors.teal800,
  };
}
