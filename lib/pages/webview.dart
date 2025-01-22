import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String redirectUrl;

  const WebViewScreen({Key? key, required this.redirectUrl}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  int _currentIndex = 0;
  String url = "";
  // Define the page paths for the navigation
  // final baseUrl = "";
  final List<String> pagePaths = [
    " ",
    "https://mypospointe.com/items",
    "https://mypospointe.com/modifers",
    "https://mypospointe.com/flash_report",
    "https://mypospointe.com/mobileview",
  ];

  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  // Build the full URL for the selected page
  String _buildUrl(String pagePath) {
    // For the first load, use the widget.redirectUrl
    // For subsequent loads, append the path to the base URL
    if (_currentIndex == 0) {
      return widget.redirectUrl; // Initial page
    } else if (_currentIndex == 1) {
      return 'https://mypospointe.com/items';
    } else if (_currentIndex == 2) {
      return 'https://mypospointe.com/modifers';
    } else if (_currentIndex == 3) {
      return 'https://mypospointe.com/flash_report';
    } else {
      return 'https://mypospointe.com/mobileview';
    }
  }

  // Initialize the WebView controller
  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        // Called when a page starts loading
        onPageStarted: (String url) {
          print("Page started loading: $url");
        },
        // Called when a page finishes loading
        onPageFinished: (String url) {
          print("Page finished loading: $url");
        },
        // Called when a navigation request is made
        onNavigationRequest: (NavigationRequest request) {
          print("Navigation request to: ${request.url}");
          return NavigationDecision.navigate; // Allow navigation
        },
      ))
      ..loadRequest(
        Uri.parse(
          _buildUrl(pagePaths[_currentIndex]),
        ),
      ); // Load the initial redirect URL
  }

  // Navigation for Bottom Navigation Bar
  void _onBottomNavigationTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Load the selected page based on the Bottom Navigation Bar tap
    _webViewController.loadRequest(
      Uri.parse(
        _buildUrl(pagePaths[_currentIndex]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("My POS Pointe"),
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          body: WebViewWidget(controller: _webViewController),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onBottomNavigationTapped, // Handle bottom navigation tap
            type: BottomNavigationBarType.fixed,
            iconSize: 20,
            selectedLabelStyle: const TextStyle(
              color: Color.fromARGB(255, 240, 239, 239),
              fontWeight: FontWeight.w500,
            ),
            selectedItemColor: const Color.fromARGB(255, 150, 147, 147),
            unselectedItemColor: const Color.fromRGBO(0, 0, 0, 1),
            selectedFontSize: 15,
            unselectedFontSize: 15,
            selectedIconTheme: const IconThemeData(
              color: const Color.fromARGB(255, 150, 147, 147),
            ),
            unselectedIconTheme: const IconThemeData(
              color: Color.fromRGBO(5, 5, 5, 1),
            ),
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: "Dashboard",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_shopping_cart_outlined),
                label: "Items",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fastfood_outlined),
                label: "Modifers",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_outlined),
                label: "Flash Report",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_outlined),
                label: "Menu",
              ),
            ],
          ),
        ));
  }
}
