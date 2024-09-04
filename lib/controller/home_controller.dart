import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/controller/provider.dart';
import 'package:flutter_application_e_commerce_app/view/details.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class HomePageContent extends StatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  int _selectedCategoryIndex = 0;// Index of the selected category
  List<dynamic> _products = [];// List to hold fetched products
  bool _isLoading = true; // Loading state for fetching products
  bool _hasError = false;

  List<Map<String, dynamic>> categories = [
    {'name': '', 'icon': Icons.watch},
    {'name': '', 'icon': Icons.shopping_bag},
    {'name': '', 'icon': Icons.shopping_cart},
    {'name': '', 'icon': Icons.shopping_basket},
    {'name': '', 'icon': Icons.diamond},
    {'name': '', 'icon': Icons.electrical_services},
    {'name': '', 'icon': Icons.book},
    {'name': '', 'icon': Icons.toys},
    {'name': '', 'icon': Icons.sports},
    {'name': '', 'icon': Icons.brush},
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch products from the API
  }
  // Function to fetch products from the API

  Future<void> _fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        setState(() {
          _products = json.decode(response.body);
          _isLoading = false;
          _hasError = false;
        });
      } else {
        print('Failed to load products: ${response.body}');
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: 8.0),
            child: Text(
              'Products List',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Text(
              'Let\'s get some things?',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
       
         
          SizedBox(height: 8),
         
          SizedBox(height: 16),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _hasError
                  ? Center(child: Text('Failed to load products'))
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: GridView.builder(
                        physics:
                            NeverScrollableScrollPhysics(), // Disable scrolling for the grid view
                        shrinkWrap:
                            true, // Ensure the grid view takes only the necessary space
                        itemCount: _products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 2
                              : 4, // Change number of columns based on orientation
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final product =
                              _products[index]; // Get product details
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsPage(productId: product['id'])),
                              );
                            },
                            child: buildProductContainer(
                              imageUrl: product['image'],
                              productName: product['title'],
                              price: '\$${product['price']}',
                              product: product,
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
 // Widget to build discount banners
  Widget buildDiscountContainer({
    required Color color,
    required String leftText,
    required String buttonText,
    required Color buttonColor,
    required Color buttonTextColor,
  }) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(right: 10, left: 12),
          height: MediaQuery.of(context).size.height / 4.4,
          width: MediaQuery.of(context).size.width / 1.2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Positioned(
          top: 25,
          left: 35,
          child: Text(
            leftText,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 19,
            ),
          ),
        ),
        Positioned(
          right: 200,
          left: 35,
          top: 110,
          bottom: 25,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(buttonColor),
            ),
            onPressed: () {},
            child: Text(
              buttonText,
              style: TextStyle(color: buttonTextColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProductContainer({
    required String imageUrl,
    required String productName,
    required String price,
    required Map<String, dynamic> product,
  }) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(20.5),
                child: Container(
                  // padding: EdgeInsets.only(top: 10.0),
                  height: 90,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.contain,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(8.0), // Added
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0.0), // Added
                        child: Text(
                          productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                  '30% OFF',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: -4,
            child: Consumer<CartProvider>(
              builder: (context, cart, child) {
                bool isInFavorite = cart.favoriteItems
                    .any((item) => item['id'] == product['id']);
                return IconButton(
                  icon: Icon(
                    isInFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isInFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    if (isInFavorite) {
                      cart.removeFavorite(product['id']);
                    } else {
                      cart.addFavorite(product);
                    }
                  },
                );
              },
            ),
          ),

          // Positioned(
          //   top: -10,
          //   right: -4,
          //   child: Consumer<CartProvider>(
          //     builder: (context, cart, child) {
          //       bool isInCart = cart.items.any((item) => item['id'] == product['id']);
          //       return IconButton(
          //         icon: Icon(
          //           isInCart ? Icons.favorite : Icons.favorite_border,
          //           color: isInCart ? Colors.grey : Colors.grey,
          //         ),
          //         onPressed: () {
          //           if (isInCart) {
          //             cart.removeItem(product['id']);
          //           } else {
          //             cart.addItem(product);
          //           }
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
