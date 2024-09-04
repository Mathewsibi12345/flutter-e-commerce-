import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/controller/provider.dart';
import 'package:flutter_application_e_commerce_app/view/mycart.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart'; 

class DetailsController {
  int _selectedButtonIndex = 2; // Default index for the selected button
  List<int> buttonNumbers = [35, 36, 37, 38, 39, 40]; // Available sizes for the product

  List<String> imgList = [];
  Map<String, dynamic>? productDetails;
  int _currentIndex = 0; // Variable to track current index

  Future<Map<String, dynamic>> fetchProductDetails(int productId) async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/$productId'));

    if (response.statusCode == 200) {
      final productDetails = json.decode(response.body); // Decode JSON response
      if (productDetails.containsKey('image')) {
        imgList = [productDetails['image']]; // Add the product image to imgList
      }
      return productDetails;
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Widget buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          width: 10.0,
          height: 10.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == index
                ? Colors.deepOrange
                : Colors.white,
          ),
        );
      }),
    );
  }

  Widget buildDetailsView(BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot, Function setState) {
    productDetails = snapshot.data!; // Get product details from the snapshot

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            color: Color.fromARGB(41, 158, 158, 158),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(240), bottomRight: Radius.circular(240)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: [
                    Image.network(productDetails!['image'], fit: BoxFit.contain)
                  ],
                ),
                Positioned(
                  bottom: 10.0,
                  left: 0.0,
                  right: 0.0,
                  child: buildDotIndicator(), // Show dot indicators
                ),
              ],
            ),
          ),
        ),
        // Container for product details
        Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
          ),
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Align children to the start
            children: [
              Text(
                productDetails!['title'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  ...List.generate(5, (index) {
                    return Icon(Icons.star, color: Colors.yellow);
                  }),
                  SizedBox(width: 8.0),
                  Text(
                    "(4500 Reviews)",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Text(
                    '\$${productDetails!['price']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.deepOrange),
                  ),
                  SizedBox(width: 16),
                  Text(
                    '\$200',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Available in stock',
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    productDetails!['description'],
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  SizedBox(height: 16.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: buttonNumbers.asMap().entries.map((entry) {
                        int index = entry.key;
                        int buttonNumber = entry.value;
                        bool isSelected = index == _selectedButtonIndex;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedButtonIndex = index; // Update selected button index
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: isSelected ? Colors.white : Colors.black,
                              backgroundColor: isSelected ? Colors.deepOrange : Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            ),
                            child: Text(buttonNumber.toString()),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (productDetails != null) {
                              // Create an item map with product details
                              Map<String, dynamic> item = {
                                'id': productDetails!['id'],
                                'name': productDetails!['title'],
                                'price': productDetails!['price'],
                                'size': buttonNumbers[_selectedButtonIndex],
                                'imageUrl': productDetails!['image'],
                                'quantity': 1
                              };
                              // Add the item to the cart
                              Provider.of<CartProvider>(context, listen: false).addItem(item);

                              // Show notification
                              _showNotification(productDetails!['title']);

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MyCart()),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.deepOrange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text('Add to Cart'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Shows a notification when an item is added to the cart
  void _showNotification(String productName) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Item Added to Cart',
        body: '$productName has been added to your cart.',
        notificationLayout: NotificationLayout.BigText,
      ),
    );
  }

  // Function to navigate back to the previous screen
  void navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
