import 'package:flutter/material.dart';
import 'package:pos_pointe/pages/home_page.dart';
import 'package:pos_pointe/pages/items.dart';
import 'package:pos_pointe/pages/menu.dart';
import 'package:pos_pointe/pages/report.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> pages = [
    const Navigation(),
    const ReportPage(),
    const ItemsPage(),
    const MenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex], // Show the page based on the selected index
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType
            .fixed, // Ensure items are displayed correctly
        currentIndex: selectedIndex, // Track the selected index
        iconSize: 30, // Adjust the size of the icons
        onTap: navigateBottomBar, // Update the selected index on tap
        selectedLabelStyle: const TextStyle(color: Colors.black),
        selectedItemColor: Colors.black, // Set the selected item color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
            backgroundColor:
                Colors.white, // Set the background color of the items
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
              color: Colors.black,
            ),
            label: 'Report',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.integration_instructions,
              color: Colors.black,
            ),
            label: 'Items',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_book_rounded,
              color: Colors.black,
            ),
            label: 'Menu',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
