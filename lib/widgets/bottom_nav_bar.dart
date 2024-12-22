// import 'package:flutter/material.dart';
// import 'package:pos_pointe/pages/home_page.dart';
// import 'package:pos_pointe/pages/items.dart';
// import 'package:pos_pointe/pages/report.dart';
// import 'package:pos_pointe/pages/settings.dart';

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({Key? key}) : super(key: key);

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int selectedIndex = 0;

//   // List of pages (cached for performance)
//   final List<Widget> _pages = [
//     HomePage(),
//     ReportPage(),
//     ItemsPage(),
//     SettingsPage(),
//   ];

//   // Handle bottom navigation item taps
//   void _navigateToPage(int index) {
//     setState(() {
//       selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         type: BottomNavigationBarType.fixed,
//         currentIndex: selectedIndex,
//         onTap: _navigateToPage,
//         iconSize: 30.0,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: const Color.fromRGBO(18, 58, 70, 1),
//         selectedFontSize: 15,
//         unselectedFontSize: 15,
//         selectedIconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//         unselectedIconTheme: const IconThemeData(
//           color: Color.fromRGBO(18, 58, 70, 1),
//         ),
//         items: const [
//           BottomNavigationBarItem(
//             label: 'Home',
//             icon: Icon(Icons.home),
//           ),
//           BottomNavigationBarItem(
//             label: 'Report',
//             icon: Icon(Icons.receipt_long_outlined),
//           ),
//           BottomNavigationBarItem(
//             label: 'Items',
//             icon: Icon(Icons.integration_instructions),
//           ),
//           BottomNavigationBarItem(
//             label: 'Settings',
//             icon: Icon(Icons.settings),
//           ),
//         ],
//       ),
//     );
//   }
// }
