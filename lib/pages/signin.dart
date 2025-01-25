import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pos_pointe/pages/webview.dart';
import 'package:pos_pointe/widgets/mybutton.dart';
import 'package:pos_pointe/widgets/textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// Add this import for url_launcher

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
  bool _isLoading = false;

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
    showError('Email and password cannot be empty');
    return;
  }

  // Encode credentials
  String encodedCredentials = encodeCredentials(email, password);
  print("Encoded Credentials: $encodedCredentials");

  setState(() {
    _isLoading = true;
  });

  try {
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

    // Fetch redirect URL after successful login
    String? redirectUrl = await fetchRedirectUrl(encodedCredentials);
    if (redirectUrl != null) {
      navigateToRedirectPage(redirectUrl); // Navigate to the fetched URL
    } else {
      showError('Redirect URL not found');
    }
  } catch (e) {
    showError('Login failed: $e');
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


 
//method to create encoded credintial
  String encodeCredentials( email, password) {
  // Combine username and password with a colon
  String credentials = '$email:$password';

  // Convert the string into a UTF-8 encoded byte array
  List<int> bytes = utf8.encode(credentials);

  // Encode the byte array into a Base64 string
  String base64Encoded = base64Encode(bytes);
print('Base64 encoded: $base64Encoded');	
  return base64Encoded;
}

  // Fetch redirect URL from API
 Future<String?> fetchRedirectUrl(String encodedCredentials) async {
  try {
    // Prepare the headers with the encoded credentials
    var headers = {
      'Authorization': 'Basic $encodedCredentials',
      'Content-Type': 'application/json',
    };

    // Prepare the request body
    var body = jsonEncode({
      'email': emailController.text.trim(),
      'password': passwordController.text,
    });

    // Create the request
    var request = http.Request(
      'POST',
      Uri.parse('https://asnitagentapi.azurewebsites.net/UserLogin/requestauth'),
    );
    request.headers.addAll(headers);
    request.body = body;

    // Send the request
    http.StreamedResponse response = await request.send();

    // Process the response
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();

      var data = jsonDecode(responseBody);

      // Extract and return the redirect URL
      String? redirectUrl = data['redirecturl'];
      print('Redirect URL: $redirectUrl');
      return redirectUrl;
    } else {
      print('Error: ${response.reasonPhrase}');
      showError('Failed to fetch redirect URL');
    }
  } catch (e) {
    print('Error fetching redirect URL: $e');
  }
  return null;
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
        showError('Invalid URL format: $redirectUrl');
      }
    } catch (e) {
      showError('Error during navigation: $e');
    }
  }

  // Dialog to ask for Biometric permission
  Future<bool?> showBiometricDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enable Biometric Login?'),
            content: Text(
                'Would you like to enable fingerprint login for next time?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Yes'),
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
    bool authenticated = await localAuth.authenticate(
      localizedReason: 'Scan your fingerprint to login',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );

    if (authenticated) {
      // Retrieve stored credentials
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? email = preferences.getString('email');
      String? password = preferences.getString('password');

      if (email != null && password != null) {
        // Generate encoded credentials
        String encodedCredentials = encodeCredentials(email, password);

        // Fetch the redirect URL
        String? redirectUrl = await fetchRedirectUrl(encodedCredentials);
        if (redirectUrl != null) {
          navigateToRedirectPage(redirectUrl); // Navigate to the fetched URL
        } else {
          showError('Redirect URL not found');
        }
      } else {
        showError('Stored credentials not found');
      }
    }
  } catch (e) {
    print('Authentication failed: $e');
  } finally {
    setState(() {
      _isAuthInProgress = false;
    });
  }
}



  // Navigate to home method
  // void navigateToHome() {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => Navigation()),
  //   );
  // }

  // Show error method
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
        if(Navigator.of(context).canPop()){
          Navigator.of(context).pop();
          return false;
        }else{
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
                    _isLoading
                        ? CircularProgressIndicator()
                        : Mybutton(
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
    ),);
  }
}
