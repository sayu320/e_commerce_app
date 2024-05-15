import 'package:ecommerce_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class Cart {
  List<CartItem> items = [];

  double getTotalPrice() {
    return items.fold(0, (total, item) => total + (item.product.price * item.quantity));
  }

void addToCart(Product product) {
  final existingItem = items.firstWhereOrNull(
    (item) => item.product.id == product.id,
  );

  if (existingItem != null) {
    existingItem.quantity++;
  } else {
    items.add(CartItem(product: product));
  }
}

  void removeFromCart(int productId) {
    items.removeWhere((item) => item.product.id == productId);
  }
}

class CartProvider with ChangeNotifier {
  Cart _cart = Cart();

  Cart get cart => _cart;

  void addToCart(Product product) {
    _cart.addToCart(product);
     notifyListeners();
  }

  void removeFromCart(int productId) {
    _cart.removeFromCart(productId);
    notifyListeners();
  }
}
