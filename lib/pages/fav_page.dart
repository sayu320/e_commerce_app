
import 'package:ecommerce_app/provider/fav_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     // Access the favourites provider
    final favouritesProvider = Provider.of<FavouritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
       // Display the list of fav items
      body: ListView.builder(
        itemCount: favouritesProvider.favourites.items.length,
        itemBuilder: (context, index) {
          final item = favouritesProvider.favourites.items[index];
          return ListTile(
            leading: Image.network(
              item.product.image,
            ),
            title: Text(item.product.title),
            subtitle: Text('\$${item.product.price}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                favouritesProvider.removeFromFavourites(item.product.id);
              },
            ),
          );
        },
      ),
    );
  }
}
