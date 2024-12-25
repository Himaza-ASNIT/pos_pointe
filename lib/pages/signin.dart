import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pos_pointe/pages/home_page.dart';
import 'package:pos_pointe/pages/signup.dart';
import 'package:pos_pointe/widgets/mybutton.dart';
import 'package:pos_pointe/widgets/squaretile.dart';
import 'package:pos_pointe/widgets/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({
    super.key,
  });

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final localAuth = LocalAuthentication(); // Local Auth instance
  final FirebaseAuth auth = FirebaseAuth.instance;
  final bool isBiometricEnablled = false;
  bool _isAuthInProgress =
      false; // Flag to track if authentication is in progress

  @override
  void initState() {
    super.initState();
    checkBiometricLogin();
  }

  //check biometric login
  Future<void> checkBiometricLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isEnabled = preferences.getBool('biometric_enabled') ?? false;
    if (isEnabled) {
      authenticateBiometric();
    }
  }

  //biometric authentication method
  Future<void> authenticateBiometric() async {
    // Prevent authentication if it's already in progress
    if (_isAuthInProgress) return;

    setState(() {
      _isAuthInProgress = true; // Mark authentication as in progress
    });

    bool authenticated = false;

    try {
      authenticated = await localAuth.authenticate(
        localizedReason: 'Scan your fingerprint to login',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        User? user = auth.currentUser;
        if (user != null) {
          navigateToHome();
        } else {
          showError('Session expired. Please log in again');
        }
      }
    } catch (e) {
      print('Authentication failed: $e');
    } finally {
      setState(() {
        _isAuthInProgress = false; // Reset the flag once done
      });
    }
  }

  //navigate to home method
  void navigateToHome() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  //show error method
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // handle emali password login
  Future<void> loginWithEmailPassword() async {
    String email = emailController.text;
    String password = passwordController.text;

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      SharedPreferences preferences = await SharedPreferences.getInstance();

      bool? enableBiometric = await showBiometricDialog();
      if (enableBiometric == true) {
        preferences.setBool('biometric_enabled', true);
      }
      navigateToHome();
    } catch (e) {
      showError('Invalid Email or Password');
    }
  }

  //dialog to ask for Biometric permission
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

  @override
  void dispose() {
    // Dispose of controllers to release resources
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                MediaQuery.of(context).size.height, // Prevent infinite height
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
                          fontWeight: FontWeight.w600),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Mybutton(
                      onTap: loginWithEmailPassword,
                      text: 'Sign In',
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Or continue with",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[400],
                              thickness: 0.5,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SquareTile(imagePath: 'assets/google.png'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not a member?",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
