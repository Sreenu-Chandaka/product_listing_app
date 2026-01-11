import 'package:dio/dio.dart';
import 'product_model.dart';

class ProductService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://fakestoreapi.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<Product>> fetchProducts({int limit = 10, int offset = 0}) async {
    try {
      final response = await _dio.get('/products');
      
      final List<dynamic> data = response.data;
      final products = data.map((json) => Product.fromJson(json)).toList();
      
      // Simulate pagination
      final start = offset;
      final end = (offset + limit).clamp(0, products.length);
      
      if (start >= products.length) {
        return [];
      }
      
      return products.sublist(start, end);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Product> fetchProductById(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection.';
    } else if (e.response?.statusCode == 404) {
      return 'Product not found.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }
}
