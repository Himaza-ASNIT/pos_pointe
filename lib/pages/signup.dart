import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pos_pointe/pages/signin.dart';
import 'package:pos_pointe/widgets/mybutton.dart';
import 'package:pos_pointe/widgets/squaretile.dart';
import 'package:pos_pointe/widgets/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final localAuth = LocalAuthentication();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isloading = false;

  // signup with email password
  Future<void> signUpWithEmailPasssword() async {
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      showErrorMessage("Password don't match");
      return;
    }
    setState(() {
      isloading = true;
    });
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      SharedPreferences preferences = await SharedPreferences.getInstance();

      bool? enableBiometric = await showBiometricDialog();

      if (enableBiometric == true) {
        preferences.setBool("Biometric enabled", true);
      }
      showSuccessMessage('Account created successfully!');
      Navigator.pop(context);
    } catch (e) {
      showErrorMessage('Failed to sign up. Try again!');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  //pop up to enable biometric login
  Future<bool?> showBiometricDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enable Biometric Login?'),
          content: Text(
              'Would you like to enable fingerprint login for the next time?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Yes'),
            )
          ],
        );
      },
    );
  }

  //method for show error messaage
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Method to show success message
  void showSuccessMessage(String messaage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(messaage),
      backgroundColor: Colors.green,
    ));
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
                  onTap: signUpWithEmailPasssword,
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SigninPage()),
                        );
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ])),
        ),
      ),
    );
  }
}
