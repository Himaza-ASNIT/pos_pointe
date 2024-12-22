import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pos_pointe/widgets/mybutton.dart';
import 'package:pos_pointe/widgets/squaretile.dart';
import 'package:pos_pointe/widgets/textfield.dart';

class SignupPage extends StatefulWidget {
  final Function()? onTap;
  const SignupPage({super.key, required this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //sign user up method
  void signUserUp() async {
    // Input Validation
    if (!validateInputs()) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      handleAuthError(e);
    } catch (e) {
      Navigator.pop(context);
      showErrorDialog("An unexpected error occurred. Please try again.");
    }
  }

// Validate all inputs
  bool validateInputs() {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showErrorDialog("Please fill in all fields.");
      return false;
    }

    if (!isValidEmail(email)) {
      showErrorDialog("Invalid email format.");
      return false;
    }

    if (password.length < 6) {
      showErrorDialog("Password must be at least 6 characters long.");
      return false;
    }

    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$').hasMatch(password)) {
      showErrorDialog(
          "Password must contain at least one letter and one number.");
      return false;
    }

    if (password != confirmPassword) {
      showErrorDialog("Passwords do not match.");
      return false;
    }

    return true;
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
      case 'email-already-in-use':
        message = "This email is already registered. Try logging in.";
        break;
      case 'operation-not-allowed':
        message = "Sign-up is currently disabled. Please contact support.";
        break;
      case 'weak-password':
        message = "The password is too weak.";
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
          title: Text("Sign Up Failed"),
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
      },
    );
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
                  "Sign Up to POS Pointe",
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
//confirm password text field
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                //sign in button
                Mybutton(
                  onTap: signUserUp,
                  text: 'Sign up',
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
                      "Already have an account?",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Sign In here",
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
