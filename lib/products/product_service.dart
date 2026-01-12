
// SIMPLIFIED PRODUCT SERVICE
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

  List<Product>? _cachedProducts;

  Future<List<Product>> fetchAllProducts({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedProducts != null) {
      return _cachedProducts!;
    }

    try {
      final response = await _dio.get('/products');
      _cachedProducts = (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
      return _cachedProducts!;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  void clearCache() => _cachedProducts = null;

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Please check your internet.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection.';
    }
    return 'Something went wrong. Please try again.';
  }
}