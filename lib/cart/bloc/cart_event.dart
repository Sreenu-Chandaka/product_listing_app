import 'package:equatable/equatable.dart';
import '../../products/product_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final Product product;

  const AddToCart(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveFromCart extends CartEvent {
  final int productId;

  const RemoveFromCart(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateQuantity extends CartEvent {
  final int productId;
  final int quantity;

  const UpdateQuantity(this.productId, this.quantity);

  @override
  List<Object?> get props => [productId, quantity];
}

class ClearCart extends CartEvent {}