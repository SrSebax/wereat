import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/features/map/domain/entities/place.dart';

/// Categoría seleccionada en los chips del home. `null` = "Todos".
class CategoryFilter extends Notifier<PlaceCategory?> {
  @override
  PlaceCategory? build() => null;

  void select(PlaceCategory? category) => state = category;
}

final categoryFilterProvider = NotifierProvider<CategoryFilter, PlaceCategory?>(
  CategoryFilter.new,
);
