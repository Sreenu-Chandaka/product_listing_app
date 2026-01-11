import 'package:flutter_bloc/flutter_bloc.dart';
import '../product_service.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService _productService;
  static const int _pageSize = 10;
  int _currentOffset = 0;

  ProductBloc(this._productService) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<RefreshProducts>(_onRefreshProducts);
    on<RetryLoadProducts>(_onRetryLoadProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      _currentOffset = 0;
      final products = await _productService.fetchProducts(
        limit: _pageSize,
        offset: _currentOffset,
      );
      _currentOffset += _pageSize;
      emit(ProductLoaded(
        products: products,
        hasMore: products.length == _pageSize,
      ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProductLoaded || 
        !currentState.hasMore || 
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final newProducts = await _productService.fetchProducts(
        limit: _pageSize,
        offset: _currentOffset,
      );
      
      _currentOffset += _pageSize;

      emit(ProductLoaded(
        products: [...currentState.products, ...newProducts],
        hasMore: newProducts.length == _pageSize,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      _currentOffset = 0;
      final products = await _productService.fetchProducts(
        limit: _pageSize,
        offset: _currentOffset,
      );
      _currentOffset += _pageSize;
      emit(ProductLoaded(
        products: products,
        hasMore: products.length == _pageSize,
      ));
    } catch (e) {
      // Keep current state on refresh error
      if (state is ProductLoaded) {
        return;
      }
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onRetryLoadProducts(
    RetryLoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    add(LoadProducts());
  }
}
