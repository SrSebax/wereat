enum PriceRange { barato, normal, caro }

/// Etiquetas del rango de precio, usadas en el formulario de agregar lugar
/// y en el preview final.
extension PriceRangeStyle on PriceRange {
  String get label => switch (this) {
    PriceRange.barato => 'Barato',
    PriceRange.normal => 'Normal',
    PriceRange.caro => 'Caro',
  };

  String get symbol => switch (this) {
    PriceRange.barato => '\$',
    PriceRange.normal => '\$\$',
    PriceRange.caro => '\$\$\$',
  };
}
