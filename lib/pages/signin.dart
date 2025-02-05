import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pos_pointe/pages/webview.dart';
import 'package:pos_pointe/widgets/mybutton.dart';
import 'package:pos_pointe/widgets/textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final localAuth = LocalAuthentication();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final bool isBiometricEnablled = false;
  bool _isAuthInProgress = false;
  String? accessdb;

  @override
  void initState() {
    super.initState();
    checkBiometricLogin();
  }

  // Handle email-password login
  Future<void> loginWithEmailPassword() async {
    String email = emailController.text.trim();
    String password = passwordController.text;

    // Check if email and password are not empty
    if (email.isEmpty || password.isEmpty) {
      showError(context,'Email and password cannot be empty');
      return;
    }

    // Encode credentials
    String encodedCredentials = encodeCredentials(email, password);
    print("Encoded Credentials: $encodedCredentials");

    setState(() {});

    try {
      // Fetch redirect URL after successful login
      String? redirectUrl = await fetchRedirectUrl(encodedCredentials);
      if (redirectUrl != null) {
        SharedPreferences preferences = await SharedPreferences.getInstance();

      // Prompt user for biometric login
      bool? enableBiometric = await showBiometricDialog();
      if (enableBiometric == true) {
        preferences.setBool('biometric_enabled', true);

        // Store credentials securely
        await preferences.setString('email', email);
        await preferences.setString('password', password);
        await preferences.setString('encoded_credentials', encodedCredentials);
        print('Biometric login enabled, credentials stored.');
      }
        await registerDevice();
        navigateToRedirectPage(redirectUrl); // Navigate to the fetched URL
      } 
      
    } catch (e) {
      showError(context,'Login failed: $e');
    } finally {
      setState(() {});
    }
  }

//method to create encoded credintial
  String encodeCredentials(email, password) {
    String credentials = '$email:$password';
    List<int> bytes = utf8.encode(credentials);
    String base64Encoded = base64Encode(bytes);
    print('Base64 encoded: $base64Encoded');
    return base64Encoded;
  }

  // Fetch redirect URL from API
  Future<String?> fetchRedirectUrl(String encodedCredentials) async {
    try {
      var headers = {
        'Permissions': 'mobileapp',
        'Authorization': 'Basic $encodedCredentials',
        'Content-Type': 'application/json',
      };

      var body = jsonEncode({
        'email': emailController.text.trim(),
        'password': passwordController.text,
      });

      // Create the request
      var request = http.Request(
        'POST',
        Uri.parse(
            'https://asnitagentapi.azurewebsites.net/UserLogin/requestauth'),
      );
      request.headers.addAll(headers);
      request.body = body;

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

        var data = jsonDecode(responseBody);
        String? redirectUrl = data['redirecturl'];
        accessdb = data['accessabledb'];
        return redirectUrl;
      } else {
        showError(context,'Email or password wrong');
      }
    } catch (e) {
      print('Error fetching redirect URL: $e');
    }
    return null;
  }

//Sending devices details
  Future<void> registerDevice() async {
    try {
      String os = Platform.operatingSystem;
      final FirebaseMessaging _messaging = FirebaseMessaging.instance;
      String? token = await _messaging.getToken();
      print("token: $token");

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic bW9iaWxlYXBwdjI6dmcyWUR6VVQ3ZjRHVVFQUjlnYWI=',
      };

      var body = json.encode({
        "accessdb": accessdb,
        "devicetoken": token,
        "devicetype": os,
      });
      print("device details : $body");
      var response = await http.post(
        Uri.parse('https://asnitagentapi.azurewebsites.net/MobileDevices'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Device registered successfully: ${response.body}');
      } else {
        print('Device registration failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error registering device: $e');
    }
  }

  // Navigate to redirect page
  void navigateToRedirectPage(String redirectUrl) {
    try {
      if (redirectUrl.startsWith('http') || redirectUrl.startsWith('https')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewScreen(
              redirectUrl: redirectUrl,
            ),
          ),
        );
      } else {
        showError(context,'Invalid URL format: $redirectUrl');
      }
    } catch (e) {
      showError(context,'Error during navigation: $e');
    }
  }

  // Dialog to ask for Biometric permission
  Future<bool?> showBiometricDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Enable Biometric Login?',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            content: Text(
              'Would you like to enable Biometric login for next time?',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'No',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 87, 78, 78),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Yes',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 213, 1, 0),
                    )),
              ),
            ],
          );
        });
  }

  // Check biometric login
  Future<void> checkBiometricLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isEnabled = preferences.getBool('biometric_enabled') ?? false;
    if (isEnabled) {
      authenticateBiometric();
    }
  }

  // Biometric authentication method
  Future<void> authenticateBiometric() async {
    if (_isAuthInProgress) return;

    setState(() {
      _isAuthInProgress = true;
    });

    try {
      bool canCheck = await localAuth.canCheckBiometrics;
      bool isSupported = await localAuth.isDeviceSupported();
print("can Check : $canCheck \n isSupported : $isSupported");
      if (!canCheck || !isSupported) {
        showError(context,'Biometric authentication is not supported on this device.');
        return;
      }

      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();
      bool canAuthenticate =
          availableBiometrics.contains(BiometricType.strong) ||
              availableBiometrics.contains(BiometricType.weak);

      print("Availabe: $canAuthenticate");
      if (!canAuthenticate) {
        showError(context,'No biometric authentication available');
        return;
      } else {
        bool authenticated = await localAuth.authenticate(
          localizedReason: 'Use Face ID or Fingerprint to authenticate',
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );

        if (!authenticated) {
          showError(context,'Biometric authentication failed');
          return;
        }

        // Retrieve stored credentials
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();
        String? email = preferences.getString('email');
        String? password = preferences.getString('password');

        if (email == null || password == null) {
          showError(context,'Stored credentials not found');
          return;
        }

        // Generate encoded credentials
        String encodedCredentials = encodeCredentials(email, password);

        // Fetch the redirect URL
        String? redirectUrl = await fetchRedirectUrl(encodedCredentials);

        if (redirectUrl != null) {
          navigateToRedirectPage(redirectUrl);
        } 
      }
    } catch (e) {
      // showError('Authentication error: ${e.toString()}');
      showError(context, 'Authentication error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isAuthInProgress = false;
        });
      }
    }
  }


void showError(BuildContext context, String message, {Alignment alignment = Alignment.topCenter}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: alignment == Alignment.topCenter ? 50 : null,
      bottom: alignment == Alignment.bottomCenter ? 50 : null,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 224,224,224),
            
          ),
          child: Text(
            message,
            style: const TextStyle(color: Color.fromARGB(255, 207, 18, 18), fontSize: 19, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SafeArea(
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/pos_point_bgr.png',
                        width: 200,
                        height: 200,
                      ),
                      Text(
                        "Sign In to POS Pointe",
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 25),
                      MyTextField(
                        controller: emailController,
                        hintText: "Email",
                        obscureText: false,
                      ),
                      const SizedBox(height: 25),
                      MyTextField(
                        controller: passwordController,
                        hintText: "Password",
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 25),
                      Mybutton(
                        onTap: loginWithEmailPassword,
                        text: 'Sign In',
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
