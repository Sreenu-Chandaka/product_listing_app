import 'package:flutter/material.dart';
import 'product_filter.dart';

class FilterBottomSheet extends StatefulWidget {
  final ProductFilter currentFilter;
  final List<String> availableCategories;

  const FilterBottomSheet({
    Key? key,
    required this.currentFilter,
    required this.availableCategories,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Set<String> selectedCategories;
  late double minPrice;
  late double maxPrice;
  late double minRating;
  late String sortBy;

  @override
  void initState() {
    super.initState();
    selectedCategories = Set.from(widget.currentFilter.selectedCategories);
    minPrice = widget.currentFilter.minPrice ?? 0;
    maxPrice = widget.currentFilter.maxPrice ?? 1000;
    minRating = widget.currentFilter.minRating ?? 0;
    sortBy = widget.currentFilter.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedCategories.clear();
                        minPrice = 0;
                        maxPrice = 1000;
                        minRating = 0;
                      });
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),
            
            Divider(height: 1, color: Colors.grey.shade300),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sort By
                    const Text(
                      'Sort By',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildSortChip('Name', 'name'),
                        _buildSortChip('Price: Low to High', 'price_asc'),
                        _buildSortChip('Price: High to Low', 'price_desc'),
                        _buildSortChip('Rating', 'rating'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Categories
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.availableCategories.map((category) {
                        final isSelected = selectedCategories.contains(category);
                        return FilterChip(
                          label: Text(
                            category[0].toUpperCase() + category.substring(1),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedCategories.add(category);
                              } else {
                                selectedCategories.remove(category);
                              }
                            });
                          },
                          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                          checkmarkColor: Theme.of(context).primaryColor,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Price Range
                    const Text(
                      'Price Range',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text('\$${minPrice.toInt()}'),
                        Expanded(
                          child: RangeSlider(
                            values: RangeValues(minPrice, maxPrice),
                            min: 0,
                            max: 1000,
                            divisions: 20,
                            onChanged: (values) {
                              setState(() {
                                minPrice = values.start;
                                maxPrice = values.end;
                              });
                            },
                          ),
                        ),
                        Text('\$${maxPrice.toInt()}'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Minimum Rating
                    const Text(
                      'Minimum Rating',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: minRating,
                            min: 0,
                            max: 5,
                            divisions: 10,
                            label: minRating.toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() {
                                minRating = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDark 
                                ? Colors.grey.shade800 
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                minRating.toStringAsFixed(1),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Apply Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final filter = ProductFilter(
                      selectedCategories: selectedCategories,
                      minPrice: minPrice > 0 ? minPrice : null,
                      maxPrice: maxPrice < 1000 ? maxPrice : null,
                      minRating: minRating > 0 ? minRating : null,
                      sortBy: sortBy,
                    );
                    Navigator.pop(context, filter);
                  },
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = sortBy == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            sortBy = value;
          });
        }
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
    );
  }
}