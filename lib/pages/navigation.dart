import 'package:flutter/material.dart';
import 'package:pos_pointe/pages/home_page.dart';
import 'package:pos_pointe/pages/items.dart';
import 'package:pos_pointe/pages/modifire.dart';
import 'package:pos_pointe/pages/report.dart';

class Navigation extends StatefulWidget {
  final String? redirectUrl; // Accept redirectUrl as a parameter

  const Navigation({super.key, this.redirectUrl});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectedIndex = 0;

  // Map routes to specific indices in the BottomNavigationBar
  final Map<String, int> routeMappings = {
    '/dashboard': 0,
    '/items': 1,
    '/modifers': 2,
    '/flash_report': 3,
  };

  // Pages corresponding to each BottomNavigationBar index
  final List<Widget> pages = [
    const HomePage(),
    const ItemsPage(),
    const ModifirePage(),
    const ReportPage(),
  ];

  @override
  void initState() {
    super.initState();

    // Defer navigation to ensure the widget tree is fully built
    Future.microtask(() {
      if (widget.redirectUrl != null) {
        navigateToRedirect(widget.redirectUrl!);
      } else {
        print('No redirect URL provided. Defaulting to Home.');
      }
    });
  }

  void navigateToRedirect(String redirectUrl) {
    print('Navigating to: $redirectUrl');
    if (routeMappings.containsKey(redirectUrl)) {
      setState(() {
        selectedIndex = routeMappings[redirectUrl]!;
      });
    } else {
      print('Unknown route: $redirectUrl');
      // Optionally show a Snackbar for user feedback
      Future.microtask(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unknown route: $redirectUrl')),
        );
      });
      // Default to Home if the route is unknown
      setState(() {
        selectedIndex = 0;
      });
    }
  }

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        iconSize: 28,
        onTap: navigateBottomBar,
        selectedLabelStyle: const TextStyle(
          color: Color.fromARGB(255, 240, 239, 239),
          fontWeight: FontWeight.w600,
        ),
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromRGBO(0, 0, 0, 1),
        selectedFontSize: 15,
        unselectedFontSize: 15,
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Color.fromRGBO(5, 5, 5, 1),
        ),
        backgroundColor: const Color.fromARGB(253, 254, 0, 0),
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Report',
            icon: Icon(Icons.book),
          ),
          BottomNavigationBarItem(
            label: 'Items',
            icon: Icon(Icons.integration_instructions),
          ),
          BottomNavigationBarItem(
            label: 'Menu',
            icon: Icon(Icons.menu_book_rounded),
          ),
        ],
      ),
    );
  }
}
