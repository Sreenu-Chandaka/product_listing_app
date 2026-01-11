import 'package:equatable/equatable.dart';
import '../products/product_model.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => product.price * quantity;

  @override
  List<Object?> get props => [product.id, quantity];
}