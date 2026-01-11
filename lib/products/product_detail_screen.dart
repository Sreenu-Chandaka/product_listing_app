import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../cart/bloc/cart_bloc.dart';
import '../cart/bloc/cart_event.dart';
import 'product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Product Details'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image section with subtle background
                  Container(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    padding: const EdgeInsets.all(24),
                    child: Hero(
                      tag: 'product-${product.id}',
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                        height: 280,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Container(
                          color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                          child: Icon(
                            Icons.error,
                            size: 64,
                            color: isDark ? Colors.grey.shade700 : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Content section
                  Container(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: isDark 
                                ? Colors.blue.shade900.withOpacity(0.3)
                                : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark 
                                  ? Colors.blue.shade700
                                  : Colors.blue.shade100,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            product.category.toUpperCase(),
                            style: TextStyle(
                              color: isDark 
                                  ? Colors.blue.shade300
                                  : Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Product title
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Rating row
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.amber.shade900.withOpacity(0.2)
                                : Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                '${product.rating.rate}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' • ${product.rating.count} reviews',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark 
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Price
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).primaryColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Price: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark 
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                             Text(
  '\$${product.price.toStringAsFixed(2)}',
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: isDark ? Colors.green.shade400 : Theme.of(context).primaryColor,
    letterSpacing: -0.5,
  ),
),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        
                        // Description section
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark 
                                ? Colors.grey.shade200
                                : Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark 
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                            height: 1.6,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Fixed bottom button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<CartBloc>().add(AddToCart(product));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 12),
                            Text(
                              'Added to cart!',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.green.shade600,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.shopping_cart, size: 22),
                  label: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}