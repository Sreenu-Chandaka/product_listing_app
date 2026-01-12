import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/products/bloc/product_event.dart';
import 'package:product_listing_app/products/bloc/product_state.dart';
import 'package:product_listing_app/products/product_service.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService _productService;

  ProductBloc(this._productService) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productService.fetchAllProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      _productService.clearCache();
      final products = await _productService.fetchAllProducts(forceRefresh: true);
      emit(ProductLoaded(products: products));
    } catch (e) {
      if (state is! ProductLoaded) {
        emit(ProductError(e.toString()));
      }
    }
  }
}
