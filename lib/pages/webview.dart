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
  late WebViewController _webViewController;
  bool isLoading = true;

  final List<String> pagePaths = [
    " ",
    "https://mypospointe.com/items",
    "https://mypospointe.com/modifers",
    "https://mypospointe.com/flash_report",
    "https://mypospointe.com/mobileview",
  ];

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
  }

  // Build the full URL for the selected page
  String _buildUrl() {
    if (_currentIndex == 0) {
      return widget.redirectUrl;
    } else {
      return pagePaths[_currentIndex];
    }
  }

  // Initialize WebViewController
  void _initializeWebViewController() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          setState(() {
            // isLoading = true;
          });
        },
        onPageFinished: (String url) {
  setState(() {
    isLoading = false;
  });

  // // JavaScript to hide multiple elements
  // _webViewController.runJavaScript('''
  //   (function hideElements() {
  //     const selectors = ['.mud-appbar']; 

  //     selectors.forEach(selector => {
  //       const element = document.querySelector(selector);
  //       if (element) {
  //         element.style.display = 'none'; 
  //       } else {
  //         setTimeout(hideElements, 100); 
  //       }
  //     });
  //   })();
  // ''');
}

      ))
      ..loadRequest(Uri.parse(_buildUrl()));
  }

  // Handle Bottom Navigation Bar Tap
  void _onBottomNavigationTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _webViewController.loadRequest(Uri.parse(_buildUrl()));
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
          title: const Text("My POS Pointe"),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _webViewController),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavigationTapped,
          type: BottomNavigationBarType.fixed,
          iconSize: 20,
          selectedLabelStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          selectedItemColor: Colors.grey,
          unselectedItemColor: Colors.black,
          selectedFontSize: 15,
          unselectedFontSize: 15,
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
              label: "Modifiers",
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
      ),
    );
  }
}
