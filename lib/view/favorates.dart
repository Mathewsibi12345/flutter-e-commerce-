import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/controller/provider.dart';
import 'package:flutter_application_e_commerce_app/view/details.dart';
import 'package:provider/provider.dart';


class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Items'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.favoriteItems.isEmpty) {
            return Center(
              child: Text('No favorite items yet.'),
            );
          }
          return ListView.builder(
            itemCount: cart.favoriteItems.length,// Number of items in the favorite list
            itemBuilder: (context, index) {
              final product = cart.favoriteItems[index]; // Get product at the current index
              return ListTile(
                leading: Image.network(product['image']),
                title: Text(product['title']),
                subtitle: Text('\$${product['price']}'), // Display product price
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(productId: product['id']),
                      
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
