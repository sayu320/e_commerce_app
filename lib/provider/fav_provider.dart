import 'package:ecommerce_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class FavouritesItem {
  final Product product;

  FavouritesItem({required this.product});
}

class Favourites {
  List<FavouritesItem> items = [];

  void addToFavourites(Product product) {
    final existingItem = items.firstWhereOrNull(
      (item) => item.product.id == product.id,
    );

    if (existingItem == null) {
      items.add(FavouritesItem(product: product));
    }
  }

  void removeFromFavourites(int productId) {
    items.removeWhere((item) => item.product.id == productId);
  }

  bool isFavourite(int productId) {
    return items.any((item) => item.product.id == productId);
  }
}

class FavouritesProvider with ChangeNotifier {
  Favourites _favourites = Favourites();

  Favourites get favourites => _favourites;

  void addToFavourites(Product product) {
    _favourites.addToFavourites(product);
    notifyListeners();
  }

  void removeFromFavourites(int productId) {
    _favourites.removeFromFavourites(productId);
    notifyListeners();
  }

  bool isFavourite(int productId) {
    return _favourites.isFavourite(productId);
  }
}
