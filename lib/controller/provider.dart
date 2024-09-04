
// import 'package:flutter/material.dart';

// // CartProvider manages the state of items in the cart and favorite items
// class CartProvider with ChangeNotifier {
//   // Private lists to hold cart items and favorite items
//   List<Map<String, dynamic>> _items = [];
//   List<Map<String, dynamic>> _favoriteItems = [];

//   // Public getters to access the private lists
//   List<Map<String, dynamic>> get items => _items;
//   List<Map<String, dynamic>> get favoriteItems => _favoriteItems;

//   // Adds an item to the cart
//   void addItem(Map<String, dynamic> item) {
//     // Check if the item is already in the cart
//     int index = _items.indexWhere((element) => element['id'] == item['id']);
//     if (index != -1) {
//       // If item is found, increment the quantity
//       _items[index]['quantity'] += 1;
//     } else {
//       // If item is not found, add it with quantity 1
//       item['quantity'] = 1;
//       _items.add(item);
//     }
//     // Notify listeners to update UI
//     notifyListeners();
//   }

//   // Removes an item from the cart by its index
//   void removeItem(int index) {
//     _items.removeAt(index); // Remove item at specified index
//     notifyListeners(); // Notify listeners to update UI
//   }

//   // Adds an item to the favorites list
//   void addFavorite(Map<String, dynamic> item) {
//     // Check if item is already in favorites
//     if (!_favoriteItems.any((element) => element['id'] == item['id'])) {
//       // If not, add it to the favorites list
//       _favoriteItems.add(item);
//       notifyListeners(); // Notify listeners to update UI
//     }
//   }

//   // Removes an item from the favorites list by its ID
//   void removeFavorite(int id) {
//     _favoriteItems.removeWhere((item) => item['id'] == id); // Remove item with the specified ID
//     notifyListeners(); // Notify listeners to update UI
//   }

//   // Increments the quantity of an item in the cart
//   void incrementQuantity(int index) {
//     _items[index]['quantity']++; // Increase quantity by 1
//     notifyListeners(); // Notify listeners to update UI
//   }

//   // Decrements the quantity of an item in the cart
//   void decrementQuantity(int index) {
//     if (_items[index]['quantity'] > 1) {
//       _items[index]['quantity']--; // Decrease quantity by 1 if greater than 1
//     } else {
//       removeItem(index); // If quantity is 1, remove the item from the cart
//     }
//     notifyListeners(); // Notify listeners to update UI
//   }

//   // Calculates the total price of all items in the cart
//   double getTotalPrice() {
//     double total = 0;
//     for (var item in _items) {
//       if (item['price'] != null && item['quantity'] != null) {
//         // Calculate total price by multiplying price and quantity
//         total += (item['price'].toDouble()) * (item['quantity'] as int);
//       }
//     }
//     return total; // Return the total price
//   }

//   // Placeholder method for building details view (not implemented)
//   buildDetailsView(BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {}
// }



import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Create an instance of FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class CartProvider with ChangeNotifier {
  // Private lists to hold cart items and favorite items
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _favoriteItems = [];

  // Public getters to access the private lists
  List<Map<String, dynamic>> get items => _items;
  List<Map<String, dynamic>> get favoriteItems => _favoriteItems;

  // Adds an item to the cart
  void addItem(Map<String, dynamic> item) {
    // Check if the item is already in the cart
    int index = _items.indexWhere((element) => element['id'] == item['id']);
    if (index != -1) {
      // If item is found, increment the quantity
      _items[index]['quantity'] += 1;
    } else {
      // If item is not found, add it with quantity 1
      item['quantity'] = 1;
      _items.add(item);
    }
    // Notify listeners to update UI
    notifyListeners();
    // Show notification
    _showNotification(item);
  }

  // Removes an item from the cart by its index
  void removeItem(int index) {
    _items.removeAt(index); // Remove item at specified index
    notifyListeners(); // Notify listeners to update UI
  }

  // Adds an item to the favorites list
  void addFavorite(Map<String, dynamic> item) {
    // Check if item is already in favorites
    if (!_favoriteItems.any((element) => element['id'] == item['id'])) {
      // If not, add it to the favorites list
      _favoriteItems.add(item);
      notifyListeners(); // Notify listeners to update UI
    }
  }

  // Removes an item from the favorites list by its ID
  void removeFavorite(int id) {
    _favoriteItems.removeWhere((item) => item['id'] == id); // Remove item with the specified ID
    notifyListeners(); // Notify listeners to update UI
  }

  // Increments the quantity of an item in the cart
  void incrementQuantity(int index) {
    _items[index]['quantity']++; // Increase quantity by 1
    notifyListeners(); // Notify listeners to update UI
  }

  // Decrements the quantity of an item in the cart
  void decrementQuantity(int index) {
    if (_items[index]['quantity'] > 1) {
      _items[index]['quantity']--; // Decrease quantity by 1 if greater than 1
    } else {
      removeItem(index); // If quantity is 1, remove the item from the cart
    }
    notifyListeners(); // Notify listeners to update UI
  }

  // Calculates the total price of all items in the cart
  double getTotalPrice() {
    double total = 0;
    for (var item in _items) {
      if (item['price'] != null && item['quantity'] != null) {
        // Calculate total price by multiplying price and quantity
        total += (item['price'].toDouble()) * (item['quantity'] as int);
      }
    }
    return total; // Return the total price
  }

  // Shows a notification when an item is added to the cart
  void _showNotification(Map<String, dynamic> item) async {
    const androidNotificationDetails = AndroidNotificationDetails(
      'cart_channel_id', // Channel ID
      'Cart Notifications', // Channel Name
      channelDescription: 'Notifications for cart items',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: null,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Item Added to Cart',
      '${item['name']} has been added to your cart.',
      notificationDetails,
    );
  }

  // Placeholder method for building details view (not implemented)
  buildDetailsView(BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {}
}

