import 'dart:convert';

import 'package:ecommerce_app/pages/cart_page.dart';
import 'package:ecommerce_app/pages/fav_page.dart';
import 'package:ecommerce_app/pages/product_tile.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/provider/fav_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:ecommerce_app/models/product_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'e-Commerce app',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CartPage(),
              ));
            },
            icon: const Icon(Icons.shopping_bag),
          ),
          IconButton(onPressed:() {
             Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FavouritesPage(),
              ));
          }, icon: const Icon(Icons.favorite))
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(product: product),
                      ),
                    );
                  },
                  child: Consumer2<CartProvider, FavouritesProvider>(
                    builder: (context, cartProvider, favouritesProvider, _) {
                      final cart = cartProvider.cart;
                      final favourite = favouritesProvider.favourites;
                      final isIncart = cart.items
                          .any((item) => item.product.id == product.id);
                      final isFavourite = favourite.isFavourite(product.id);

                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                product.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product.title.split(' ').take(3).join(' '),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (!isIncart) {
                                      cartProvider.addToCart(product);
                                    }
                                  },
                                  icon: Icon(
                                    !isIncart
                                        ? Icons.add_circle
                                        : Icons.check_circle,
                                  ),
                                  color: isIncart ? Colors.blue : Colors.green,
                                ),
                                 IconButton(
                              onPressed: () {
                                if (!isFavourite) {
                                  favouritesProvider.addToFavourites(product);
                                } else {
                                  favouritesProvider
                                      .removeFromFavourites(product.id);
                                }
                              },
                              icon: Icon(
                                isFavourite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              color: isFavourite ? Colors.red : Colors.grey,
                            ),
                              ],
                            ),
                           
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
