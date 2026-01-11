class ProductFilter {
  final Set<String> selectedCategories;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final String sortBy; // 'price_asc', 'price_desc', 'rating', 'name'

  ProductFilter({
    this.selectedCategories = const {},
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.sortBy = 'name',
  });

  ProductFilter copyWith({
    Set<String>? selectedCategories,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sortBy,
  }) {
    return ProductFilter(
      selectedCategories: selectedCategories ?? this.selectedCategories,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasActiveFilters =>
      selectedCategories.isNotEmpty ||
      minPrice != null ||
      maxPrice != null ||
      minRating != null;

  int get activeFilterCount {
    int count = 0;
    if (selectedCategories.isNotEmpty) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (minRating != null) count++;
    return count;
  }

  ProductFilter clear() {
    return ProductFilter(sortBy: sortBy);
  }
}