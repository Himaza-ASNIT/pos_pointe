import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pos_pointe/widgets/mybutton.dart';
import 'package:pos_pointe/widgets/squaretile.dart';
import 'package:pos_pointe/widgets/textfield.dart';

class SigninPage extends StatefulWidget {
  final Function()? onTap;
  const SigninPage({super.key, required this.onTap});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication(); // Local Auth instance

  //sign user in method
  void signUserIn() async {
    // Input Validation
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showErrorDialog("Please fill in all fields.");
      return;
    }

    if (!isValidEmail(emailController.text)) {
      showErrorDialog("Invalid email format.");
      return;
    }

    // Show loading indicator
    showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismiss while loading
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
      }

      // Biometric authentication check
      bool canAuthenticate = await auth.canCheckBiometrics;
      if (canAuthenticate) {
        bool isAuthenticated = await authenticateWithBiometrics();
        if (isAuthenticated && mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          if (mounted) {
            showErrorDialog(
                "Biometric authentication failed. Please login again.");
          }
        }
      } else {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        handleAuthError(e);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        showErrorDialog("An unexpected error occurred. Please try again.");
      }
    }
  }

  // Authenticate with biometrics
  Future<bool> authenticateWithBiometrics() async {
    try {
      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return isAuthenticated;
    } catch (e) {
      return false;
    }
  }

  // Validate email format
  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);
  }

  // Handle Firebase-specific errors
  void handleAuthError(FirebaseAuthException e) {
    String message = "An error occurred. Please try again.";

    switch (e.code) {
      case 'invalid-email':
        message = "The email address is not valid.";
        break;
      case 'user-disabled':
        message = "This user account has been disabled.";
        break;
      case 'user-not-found':
        message = "No user found with this email.";
        break;
      case 'wrong-password':
        message = "Incorrect password. Please try again.";
        break;
      case 'too-many-requests':
        message = "Too many login attempts. Try again later.";
        break;
      case 'network-request-failed':
        message = "Network error. Please check your connection.";
        break;
      default:
        message = e.message ?? "An unexpected error occurred.";
    }
    showErrorDialog(message);
  }

  // Show error dialog
  void showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Sign In Failed"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              )
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
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/pos_point_bgr.png', // Path to your image
                  width: 200,
                  height: 200,
                ),

                // Welcome back text
                Text(
                  "Sign In to POS Pointe",
                  style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 25),

                // email text field
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 25),

                // Password text field
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // forgot password
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

                //sign in button
                Mybutton(
                  onTap: signUserIn,
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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

                //signup here!
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
                      onTap: widget.onTap,
                      child: const Text(
                        "Sign Up here",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
