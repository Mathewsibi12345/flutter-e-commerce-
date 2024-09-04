

import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/controller/home_controller.dart';
import 'package:flutter_application_e_commerce_app/controller/provider.dart';
import 'package:flutter_application_e_commerce_app/controller/theam.dart';
import 'package:flutter_application_e_commerce_app/view/favorates.dart';
import 'package:flutter_application_e_commerce_app/view/profile.dart';
import 'package:provider/provider.dart';

import 'mycart.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
    HomePageContent(),
    FavoritePage(),
    Placeholder(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Search Bar with Theme Toggle
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (value) {
                        // Handle search functionality here
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                    onPressed: () {
                      final isDarkMode = themeProvider.isDarkMode;
                      themeProvider.toggleTheme(!isDarkMode);
                    },
                  ),
                ],
              ),
            ),
            Expanded(child: _pages[_selectedIndex]), // Display the currently selected page
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Icon(
                  Icons.home,
                  color: _selectedIndex == 0 ? Color(0xFFF16B26) : Colors.grey,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Icon(
                  Icons.favorite_border,
                  color: _selectedIndex == 1 ? Color(0xFFF16B26) : Colors.grey,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Icon(
                          Icons.shopping_cart,
                          color: _selectedIndex == 2
                              ? Color(0xFFF16B26)
                              : Colors.grey,
                        ),
                      ),
                      if (cart.items.length > 0)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: Text(
                              '${cart.items.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Icon(
                  Icons.person,
                  color: _selectedIndex == 3 ? Color(0xFFF16B26) : Colors.grey,
                ),
              ),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
